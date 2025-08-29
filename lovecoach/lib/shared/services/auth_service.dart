import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/survey_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        return await _getOrCreateUserModel(credential.user!);
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String password, String displayName) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        
        // 이메일 인증 메일 발송
        await credential.user!.sendEmailVerification();
        
        return await _createUserModel(credential.user!, displayName: displayName);
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 이메일 인증 상태 확인
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  // 이메일 인증 메일 재발송
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception('이미 인증된 계정이거나 로그인이 필요합니다.');
    }
  }

  // 비밀번호 재설정 이메일 발송
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 이메일 인증 상태 새로고침
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
    
    // Firestore의 사용자 데이터도 업데이트
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'emailVerified': user.emailVerified,
        'updatedAt': DateTime.now(),
      });
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Firestore에서 사용자 데이터 삭제
      await _firestore.collection('users').doc(user.uid).delete();
      
      // 사용자의 모든 채팅 기록 삭제
      final chatQuery = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      final batch = _firestore.batch();
      for (final doc in chatQuery.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Firebase Auth에서 계정 삭제
      await user.delete();
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      // 웹에서는 Google Sign-In이 제한적이므로 임시로 알림만 표시
      throw Exception('Google 로그인은 현재 웹에서 지원되지 않습니다. 이메일 로그인을 사용해주세요.');
    } catch (e) {
      print('Google 로그인 오류: $e');
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    // Google 로그아웃은 웹에서는 생략
  }

  Future<UserModel> _getOrCreateUserModel(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    
    if (doc.exists) {
      return UserModel.fromFirestore(doc.data()!, doc.id);
    } else {
      return await _createUserModel(user);
    }
  }

  Future<UserModel> _createUserModel(User user, {String? displayName}) async {
    final userModel = UserModel(
      id: user.uid,
      email: user.email!,
      displayName: displayName ?? user.displayName,
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toFirestore());
    return userModel;
  }

  Stream<UserModel> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          var data = doc.data()!;
          // Firebase Auth의 실시간 이메일 인증 상태를 반영
          data['emailVerified'] = _firebaseAuth.currentUser?.emailVerified ?? false;
          return UserModel.fromFirestore(data, doc.id);
        });
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(user.copyWith(updatedAt: DateTime.now()).toFirestore());
  }

  Future<void> updateSurveyCompletion(String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update({
          'hasCompletedSurvey': true,
          'updatedAt': DateTime.now(),
        });
  }

  Future<void> saveSurveyData(String userId, SurveyModel surveyData) async {
    // 설문조사 완료 여부 검증
    if (!surveyData.isComplete) {
      throw Exception('설문조사가 완전히 작성되지 않았습니다. 모든 항목을 작성해주세요.');
    }
    
    final batch = _firestore.batch();
    
    // 설문조사 결과를 surveys 컬렉션에 저장
    final surveyRef = _firestore.collection('surveys').doc(userId);
    batch.set(surveyRef, surveyData.toFirestore());
    
    // 사용자 정보 업데이트 (설문조사 완료 상태)
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'hasCompletedSurvey': true,
      'updatedAt': DateTime.now(),
    });
    
    await batch.commit();
  }

  Future<SurveyModel?> getSurveyData(String userId) async {
    try {
      final doc = await _firestore.collection('surveys').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return SurveyModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      print('설문조사 데이터 조회 오류: $e');
      return null;
    }
  }

  Stream<SurveyModel?> getSurveyStream(String userId) {
    return _firestore
        .collection('surveys')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return SurveyModel.fromFirestore(doc.data()!);
          }
          return null;
        });
  }

  // 테스트 계정 생성 (개발용)
  Future<UserModel?> createTestAccount() async {
    const testEmail = 'test@lovecoach.app';
    const testPassword = 'test123456';
    const testName = '테스트 사용자';

    try {
      // 기존 테스트 계정이 있는지 확인
      final existingUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      
      if (existingUser.user != null) {
        // 이미 계정이 있으면 바로 반환
        return await _getOrCreateUserModel(existingUser.user!);
      }
    } catch (e) {
      // 계정이 없으면 새로 생성
    }

    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      
      if (credential.user != null) {
        await credential.user!.updateDisplayName(testName);
        
        // 테스트 계정은 이메일 인증 없이 바로 활성화
        await credential.user!.reload();
        
        return await _createUserModel(credential.user!, displayName: testName);
      }
      return null;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return '등록되지 않은 이메일입니다.';
        case 'wrong-password':
          return '비밀번호가 틀렸습니다.';
        case 'email-already-in-use':
          return '이미 사용 중인 이메일입니다.';
        case 'weak-password':
          return '비밀번호가 너무 약합니다.';
        case 'invalid-email':
          return '잘못된 이메일 형식입니다.';
        case 'too-many-requests':
          return '너무 많은 시도가 있었습니다. 나중에 다시 시도해주세요.';
        default:
          return '로그인에 실패했습니다. 다시 시도해주세요.';
      }
    }
    return '알 수 없는 오류가 발생했습니다.';
  }
}