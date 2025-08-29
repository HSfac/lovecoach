import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/inquiry_model.dart';
import '../models/user_model.dart';

class InquiryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 새로운 문의를 생성하고 관리자에게 알림을 보냅니다
  Future<bool> submitInquiry({
    required String message,
    UserModel? currentUser,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('로그인이 필요합니다.');

      final userEmail = currentUser?.email ?? user.email ?? '';
      final userId = user.uid;

      // 문의 데이터 생성
      final inquiry = InquiryModel(
        id: '', // Firestore가 자동 생성
        userId: userId,
        userEmail: userEmail,
        message: message.trim(),
        status: 'pending',
        createdAt: DateTime.now(),
      );

      // Firestore에 저장
      final docRef = await _firestore
          .collection('inquiries')
          .add(inquiry.toFirestore());

      // 관리자 알림을 위한 데이터 추가
      await _firestore
          .collection('admin_notifications')
          .add({
            'type': 'new_inquiry',
            'inquiryId': docRef.id,
            'userEmail': userEmail,
            'message': message.length > 50 
                ? '${message.substring(0, 50)}...' 
                : message,
            'createdAt': DateTime.now(),
            'isRead': false,
          });

      // Firebase Functions를 통한 이메일 알림 (선택사항)
      await _sendEmailNotification(docRef.id, userEmail, message);

      return true;
    } catch (e) {
      print('문의 제출 오류: $e');
      throw Exception('문의 제출 중 오류가 발생했습니다: $e');
    }
  }

  /// 사용자의 문의 목록을 가져옵니다
  Future<List<InquiryModel>> getUserInquiries() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final querySnapshot = await _firestore
          .collection('inquiries')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => InquiryModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('문의 목록 조회 오류: $e');
      return [];
    }
  }

  /// 사용자의 문의 목록 스트림을 반환합니다
  Stream<List<InquiryModel>> getUserInquiriesStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('inquiries')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InquiryModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  /// 특정 문의의 세부 정보를 가져옵니다
  Future<InquiryModel?> getInquiryById(String inquiryId) async {
    try {
      final doc = await _firestore
          .collection('inquiries')
          .doc(inquiryId)
          .get();

      if (doc.exists && doc.data() != null) {
        return InquiryModel.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('문의 조회 오류: $e');
      return null;
    }
  }

  /// Firebase Functions를 통해 관리자에게 이메일 알림을 보냅니다
  Future<void> _sendEmailNotification(
    String inquiryId,
    String userEmail,
    String message,
  ) async {
    try {
      // Firebase Functions 호출
      // 실제 구현에서는 httpsCallable을 사용하세요
      // final callable = FirebaseFunctions.instance.httpsCallable('sendInquiryNotification');
      // await callable.call({
      //   'inquiryId': inquiryId,
      //   'userEmail': userEmail,
      //   'message': message,
      // });

      // 지금은 로그만 출력
      print('이메일 알림 요청: $userEmail에서 문의 접수 ($inquiryId)');
    } catch (e) {
      // 이메일 알림 실패는 전체 프로세스를 중단시키지 않습니다
      print('이메일 알림 전송 실패: $e');
    }
  }

  /// 문의 상태를 업데이트합니다 (관리자용)
  Future<void> updateInquiryStatus(
    String inquiryId,
    String status, {
    String? adminReply,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updatedAt': DateTime.now(),
      };

      if (adminReply != null && adminReply.isNotEmpty) {
        updateData['adminReply'] = adminReply;
      }

      if (status == 'resolved') {
        updateData['resolvedAt'] = DateTime.now();
      }

      await _firestore
          .collection('inquiries')
          .doc(inquiryId)
          .update(updateData);
    } catch (e) {
      print('문의 상태 업데이트 오류: $e');
      throw Exception('문의 상태 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  /// 미답변 문의 수를 반환합니다 (관리자용)
  Future<int> getPendingInquiriesCount() async {
    try {
      final querySnapshot = await _firestore
          .collection('inquiries')
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('미답변 문의 수 조회 오류: $e');
      return 0;
    }
  }
}