import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/daily_reset_service.dart';
import '../models/user_model.dart';
import '../models/survey_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final currentUserProvider = StreamProvider<UserModel?>((ref) async* {
  final authState = ref.watch(authStateProvider);
  
  yield* authState.when(
    data: (user) async* {
      if (user != null) {
        final authService = ref.read(authServiceProvider);
        final dailyResetService = DailyResetService();
        
        await for (final userData in authService.getUserStream(user.uid)) {
          if (userData != null) {
            // 로그인 시 일일 상담 상태 체크 및 필요시 리셋
            final wasReset = await dailyResetService.checkAndResetUserDailyConsultation(
              userData.id, 
              userData.lastConsultationDate,
            );
            
            if (wasReset) {
              // 리셋된 경우 업데이트된 데이터 다시 가져오기
              yield* authService.getUserStream(user.uid);
              return;
            }
          }
          yield userData;
        }
      } else {
        yield null;
      }
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});

// 설문조사 데이터 스트림 Provider
final surveyDataProvider = StreamProvider<SurveyModel?>((ref) async* {
  final user = ref.watch(currentUserProvider);
  
  yield* user.when(
    data: (userData) async* {
      if (userData != null) {
        final authService = ref.read(authServiceProvider);
        yield* authService.getSurveyStream(userData.id);
      } else {
        yield null;
      }
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  
  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    ref.listen(currentUserProvider, (previous, next) {
      state = next;
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithEmail(email, password);
      return user != null;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password, String displayName) async {
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider);
      final user = await authService.signUpWithEmail(email, password, displayName);
      return user != null;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      return user != null;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendPasswordResetEmail(email);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendEmailVerification();
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<void> reloadUser() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.reloadUser();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  bool get isEmailVerified {
    final authService = ref.read(authServiceProvider);
    return authService.isEmailVerified;
  }

  Future<bool> deleteAccount() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.deleteAccount();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> createTestAccount() async {
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider);
      final user = await authService.createTestAccount();
      return user != null;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> completeSurvey() async {
    try {
      final currentUserData = await ref.read(currentUserProvider.future);
      if (currentUserData == null) return false;

      final authService = ref.read(authServiceProvider);
      await authService.updateSurveyCompletion(currentUserData.id);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> saveSurveyData({
    required String? gender,
    required int? ageRange,
    required String? relationshipStatus,
    required List<String> interests,
    required String? communicationStyle,
  }) async {
    try {
      final currentUserData = await ref.read(currentUserProvider.future);
      if (currentUserData == null) return false;

      final surveyData = SurveyModel(
        gender: gender,
        ageRange: ageRange,
        relationshipStatus: relationshipStatus,
        interests: interests,
        communicationStyle: communicationStyle,
        completedAt: DateTime.now(),
      );

      final authService = ref.read(authServiceProvider);
      await authService.saveSurveyData(currentUserData.id, surveyData);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<SurveyModel?> getSurveyData() async {
    try {
      final currentUserData = await ref.read(currentUserProvider.future);
      if (currentUserData == null) return null;

      final authService = ref.read(authServiceProvider);
      return await authService.getSurveyData(currentUserData.id);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }
}