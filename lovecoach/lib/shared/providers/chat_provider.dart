import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/question_filter_service.dart';
import '../models/ai_model.dart';
import 'auth_provider.dart';
import 'ai_model_provider.dart';

final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier, AsyncValue<List<ChatMessage>>, ConsultationCategory>((ref, category) {
  return ChatNotifier(ref, category);
});

final chatTypingProvider = StateNotifierProvider.family<ChatTypingNotifier, bool, ConsultationCategory>((ref, category) {
  return ChatTypingNotifier();
});

class ChatTypingNotifier extends StateNotifier<bool> {
  ChatTypingNotifier() : super(false);

  void startTyping() {
    state = true;
  }

  void stopTyping() {
    state = false;
  }
}

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatMessage>>> {
  final Ref ref;
  final ConsultationCategory category;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isAiTyping = false;

  ChatNotifier(this.ref, this.category) : super(const AsyncValue.loading()) {
    _loadChatHistory();
  }

  bool get isAiTyping => _isAiTyping;

  Future<void> _loadChatHistory() async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        state = const AsyncValue.data([]);
        return;
      }

      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: false)
          .limit(50)
          .get();

      final messages = querySnapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc.data(), doc.id))
          .where((message) => message.category == category.name)
          .toList();

      state = AsyncValue.data(messages);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      final user = ref.read(authStateProvider).value;
      final currentUser = ref.read(currentUserProvider).value;
      
      if (user == null || currentUser == null) {
        throw Exception('로그인이 필요합니다.');
      }

      // 무료 사용자 횟수 체크
      if (!currentUser.canUseService) {
        throw Exception(currentUser.consultationStatusMessage);
      }
      
      // 오늘의 상담 사용 가능 여부 체크
      if (!currentUser.canUseTodayConsultation) {
        throw Exception(currentUser.consultationStatusMessage);
      }

      // 연애 관련 질문인지 확인
      if (!QuestionFilterService.isLoveRelatedQuestion(content)) {
        // 필터링 메시지를 AI 응답으로 추가
        final filterMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_filter',
          content: QuestionFilterService.getFilterMessage(),
          type: MessageType.ai,
          timestamp: DateTime.now(),
          category: category,
          userId: 'ai',
        );

        state = state.whenData((messages) => [...messages, filterMessage]);
        await _firestore.collection('chats').add(filterMessage.toFirestore());
        return;
      }

      // 사용자 메시지 추가
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: MessageType.user,
        timestamp: DateTime.now(),
        category: category,
        userId: user.uid,
      );

      // 로컬 상태 업데이트
      state = state.whenData((messages) => [...messages, userMessage]);

      // Firestore에 사용자 메시지 저장
      await _firestore.collection('chats').add(userMessage.toFirestore());

      // AI 타이핑 시작
      _isAiTyping = true;
      ref.read(chatTypingProvider(category).notifier).startTyping();
      
      // 대화 길이 체크 (20개 메시지 이상일 때)
      final currentMessages = state.value ?? [];
      if (currentMessages.length >= 20) {
        final lengthWarningMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString() + '_length_warning',
          content: '''💬 대화가 길어졌네요! 

지금까지 좋은 상담이었어요. 대화가 길어지면 맥락을 놓칠 수 있어서, 새로운 대화를 시작하는 것을 추천드려요.

🔄 **새 대화 시작하기**를 눌러서 깔끔하게 새로운 상담을 받아보세요!

물론 지금 대화를 계속하셔도 괜찮지만, 더 정확한 답변을 위해서는 새로운 대화가 좋아요 😊''',
          type: MessageType.ai,
          timestamp: DateTime.now(),
          category: category,
          userId: 'ai',
        );

        state = state.whenData((messages) => [...messages, lengthWarningMessage]);
        await _firestore.collection('chats').add(lengthWarningMessage.toFirestore());
      }

      // AI 응답 생성
      final aiService = ref.read(aiServiceProvider);
      final selectedModel = ref.read(selectedAIModelProvider);
      final conversationHistory = state.value ?? [];
      
      final aiResponse = await aiService.generateResponse(
        userMessage: content,
        category: category,
        conversationHistory: conversationHistory,
        aiModel: selectedModel,
      );

      // AI 응답 메시지 생성
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_ai',
        content: aiResponse,
        type: MessageType.ai,
        timestamp: DateTime.now(),
        category: category,
        userId: 'ai',
      );

      // 로컬 상태에 AI 응답 추가
      state = state.whenData((messages) => [...messages, aiMessage]);

      // AI 타이핑 종료
      _isAiTyping = false;
      ref.read(chatTypingProvider(category).notifier).stopTyping();
      
      // Firestore에 AI 응답 저장
      await _firestore.collection('chats').add(aiMessage.toFirestore());

      // 무료 사용자의 경우 사용 횟수 업데이트
      if (!currentUser.isSubscribed) {
        final now = DateTime.now();
        final authService = ref.read(authServiceProvider);
        
        // 오늘이 새로운 날인지 확인 (날짜가 바뀌었다면 hasUsedTodaysConsultation 리셋)
        final today = DateTime(now.year, now.month, now.day);
        final lastDate = currentUser.lastConsultationDate;
        bool shouldResetDailyUsage = false;
        
        if (lastDate == null) {
          shouldResetDailyUsage = true;
        } else {
          final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
          shouldResetDailyUsage = !lastDateOnly.isAtSameMomentAs(today);
        }
        
        await authService.updateUser(
          currentUser.copyWith(
            freeConsultationsUsed: currentUser.freeConsultationsUsed + 1,
            lastConsultationDate: now,
            hasUsedTodaysConsultation: true,
          ),
        );
      }

    } catch (e, stackTrace) {
      // AI 타이핑 종료
      _isAiTyping = false;
      ref.read(chatTypingProvider(category).notifier).stopTyping();
      
      // 에러 메시지를 AI 응답으로 표시
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString() + '_error',
        content: '죄송합니다. 현재 서비스에 문제가 발생했습니다: ${e.toString()}',
        type: MessageType.ai,
        timestamp: DateTime.now(),
        category: category,
        userId: 'ai',
      );

      state = state.whenData((messages) => [...messages, errorMessage]);
    }
  }

  Future<void> clearChat() async {
    try {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      // Firestore에서 채팅 기록 삭제
      final querySnapshot = await _firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .where('category', isEqualTo: category.name)
          .get();

      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // 로컬 상태 초기화
      state = const AsyncValue.data([]);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}