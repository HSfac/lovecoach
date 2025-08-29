import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/chat_message.dart';
import 'typewriter_text.dart';

class EnhancedMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool showAvatar;
  final bool isTyping;
  final bool useTypewriterEffect;

  const EnhancedMessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.isTyping = false,
    this.useTypewriterEffect = false,
  });

  @override
  State<EnhancedMessageBubble> createState() => _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends State<EnhancedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.type == MessageType.user;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 16,
                left: isUser ? 60 : 0,
                right: isUser ? 0 : 60,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isUser && widget.showAvatar) ...[
                    _buildAvatarWithIndicator(),
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: isUser 
                          ? CrossAxisAlignment.end 
                          : CrossAxisAlignment.start,
                      children: [
                        if (!isUser) _buildCounselorName(),
                        _buildMessageContainer(isUser),
                        const SizedBox(height: 4),
                        _buildTimestamp(isUser),
                      ],
                    ),
                  ),
                  if (isUser && widget.showAvatar) ...[
                    const SizedBox(width: 12),
                    _buildUserAvatar(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarWithIndicator() {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentColor,
                AppTheme.accentColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.psychology,
            color: Colors.white,
            size: 20,
          ),
        ),
        if (widget.isTyping)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: AppTheme.calmColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 8,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Widget _buildCounselorName() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 4),
      child: Text(
        _getCounselorName(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  Widget _buildMessageContainer(bool isUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.userMessageColor : AppTheme.aiMessageColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.isTyping 
          ? _buildTypingIndicator() 
          : _buildMessageContent(isUser),
    );
  }

  Widget _buildMessageContent(bool isUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI 메시지에 타이핑 효과 적용
        !isUser && widget.useTypewriterEffect 
          ? TypewriterText(
              text: widget.message.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: AppTheme.textPrimary,
              ),
              speed: const Duration(milliseconds: 25),
            )
          : Text(
              widget.message.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: isUser ? AppTheme.textPrimary : AppTheme.textPrimary,
              ),
            ),
        if (!isUser) ...[
          const SizedBox(height: 8),
          _buildEmotionalIndicators(),
        ],
      ],
    );
  }

  Widget _buildEmotionalIndicators() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEmotionChip('🤗', '공감'),
        const SizedBox(width: 6),
        _buildEmotionChip('💡', '조언'),
        const SizedBox(width: 6),
        _buildEmotionChip('💝', '응원'),
      ],
    );
  }

  Widget _buildEmotionChip(String emoji, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTypingDot(0),
        const SizedBox(width: 4),
        _buildTypingDot(150),
        const SizedBox(width: 4),
        _buildTypingDot(300),
        const SizedBox(width: 8),
        const Text(
          '답변을 준비 중...',
          style: TextStyle(
            fontSize: 13,
            color: AppTheme.textHint,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTypingDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(value),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      },
    );
  }

  Widget _buildTimestamp(bool isUser) {
    return Text(
      _formatTime(widget.message.timestamp),
      style: const TextStyle(
        fontSize: 11,
        color: AppTheme.textHint,
      ),
    );
  }

  String _getCounselorName() {
    switch (widget.message.category) {
      case ConsultationCategory.flirting:
        return '하트 코치';
      case ConsultationCategory.dating:
        return '러브 닥터';
      case ConsultationCategory.breakup:
        return '힐링 메이트';
      case ConsultationCategory.reconciliation:
        return '리뉴 코치';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inDays < 1) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.month}/${timestamp.day}';
    }
  }
}