import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/models/chat_message.dart';
import '../../../../shared/providers/chat_provider.dart';
import '../../../../shared/providers/ai_model_provider.dart';
import '../../../../shared/widgets/counselor_profile.dart';
import '../../../../shared/widgets/enhanced_message_bubble.dart';
import '../../../../shared/widgets/typing_indicator.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/app_localizations.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String category;
  final String? sessionId;

  const ChatScreen({super.key, required this.category, this.sessionId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ConsultationCategory _category;
  String? _latestAiMessageId;

  @override
  void initState() {
    super.initState();
    _category = ConsultationCategory.values.firstWhere(
      (e) => e.name == widget.category,
      orElse: () => ConsultationCategory.flirting,
    );
    
    // 세션 ID가 있는 경우 해당 세션을 로드
    if (widget.sessionId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(chatNotifierProvider(_category).notifier).loadSession(widget.sessionId!);
      });
    }
  }

  String _getWelcomeMessage(ConsultationCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case ConsultationCategory.flirting:
        return l10n.crushChatWelcome;
      case ConsultationCategory.dating:
        return l10n.relationshipChatWelcome;
      case ConsultationCategory.breakup:
        return l10n.breakupChatWelcome;
      case ConsultationCategory.reconciliation:
        return l10n.reunionChatWelcome;
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    // Provider를 통해 메시지 전송
    ref.read(chatNotifierProvider(_category).notifier).sendMessage(message);
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  IconData _getCategoryIcon() {
    switch (_category) {
      case ConsultationCategory.flirting:
        return Icons.favorite_border;
      case ConsultationCategory.dating:
        return Icons.favorite;
      case ConsultationCategory.breakup:
        return Icons.heart_broken;
      case ConsultationCategory.reconciliation:
        return Icons.refresh;
    }
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.refresh, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('새 대화 시작'),
          ],
        ),
        content: const Text('현재 대화를 정리하고 새로운 상담을 시작하시겠어요?\n\n이전 대화 내용은 삭제되지만, 더 정확한 상담을 받을 수 있어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatNotifierProvider(_category).notifier).clearChat();
              _showWelcomeMessage();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            child: const Text('새 대화 시작', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showWelcomeMessage() {
    // 새 대화 시작 시 환영 메시지 자동 추가
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString() + '_welcome',
      content: _getWelcomeMessage(_category),
      type: MessageType.ai,
      timestamp: DateTime.now(),
      category: _category,
      userId: 'ai',
      sessionId: '',
    );
    
    ref.read(chatNotifierProvider(_category).notifier).state = 
        AsyncValue.data([welcomeMessage]);
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('채팅 기록 삭제'),
        content: const Text('모든 대화 내용이 삭제됩니다. 계속하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chatNotifierProvider(_category).notifier).clearChat();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider(_category));
    final selectedAI = ref.watch(selectedAIModelProvider);
    final isTyping = ref.watch(chatTypingProvider(_category));

    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: Text('${_category.displayName} 상담'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundStart,
              AppTheme.backgroundEnd,
            ],
          ),
        ),
        child: Column(
          children: [
            // 상담사 프로필 헤더
            CounselorProfile(category: _category, aiModel: selectedAI),
            
            // 채팅 영역
            Expanded(
              child: chatState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('오류가 발생했습니다: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(chatNotifierProvider(_category)),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
                data: (messages) {
                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(top: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && isTyping) {
                          return const TypingIndicator();
                        }
                        
                        final message = messages[index];
                        final showAvatar = index == 0 || 
                            messages[index - 1].type != message.type;
                        final isLatestAiMessage = message.type == MessageType.ai && 
                            index == messages.length - 1;
                        
                        return EnhancedMessageBubble(
                          message: message,
                          showAvatar: showAvatar,
                          useTypewriterEffect: isLatestAiMessage,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            // 입력 영역
            _buildEnhancedInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.2),
                      AppTheme.accentColor.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  size: 30,
                  color: AppTheme.accentColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.chatGreeting,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getWelcomeMessage(_category),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundStart,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppTheme.accentColor,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '무엇이든 편하게 말씀해주세요',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '상황이 어떤지 자세히 들려주시면\n더 정확한 조언을 드릴 수 있어요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 빠른 응답 버튼들 (선택사항)
            _buildQuickReplies(),
            const SizedBox(height: 12),
            
            // 메시지 입력 영역
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundStart,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '고민을 자유롭게 말씀해주세요...',
                        hintStyle: TextStyle(
                          color: AppTheme.textHint,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.chat_bubble_outline,
                          color: AppTheme.textHint,
                          size: 20,
                        ),
                      ),
                      maxLines: null,
                      maxLength: 500,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    final quickReplies = _getQuickReplies(_category);
    if (quickReplies.isEmpty) return const SizedBox.shrink();
    
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickReplies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final reply = quickReplies[index];
          return InkWell(
            onTap: () {
              _messageController.text = reply;
              _sendMessage();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                reply,
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: AppTheme.primaryColor),
              title: const Text('새 대화 시작하기'),
              onTap: () {
                Navigator.pop(context);
                _showNewChatDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('대화 내용 삭제'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark_border, color: AppTheme.accentColor),
              title: const Text('중요한 대화 저장'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 대화 저장 기능
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined, color: AppTheme.primaryColor),
              title: const Text('상담 피드백'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 피드백 기능
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<String> _getQuickReplies(ConsultationCategory category) {
    switch (category) {
      case ConsultationCategory.flirting:
        return ['어떻게 접근해야 할까요?', '상대방 마음을 알고 싶어요', '첫 데이트 제안이 어려워요'];
      case ConsultationCategory.dating:
        return ['자주 싸우게 돼요', '연인과 소통이 힘들어요', '관계를 발전시키고 싶어요'];
      case ConsultationCategory.breakup:
        return ['너무 힘들어요', '잊을 수가 없어요', '다시 시작하고 싶어요'];
      case ConsultationCategory.reconciliation:
        return ['다시 연락하고 싶어요', '관계 회복이 가능한가요?', '어떻게 사과해야 할까요?'];
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

