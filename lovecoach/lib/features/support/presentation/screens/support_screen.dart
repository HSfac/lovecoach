import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/providers/inquiry_provider.dart';
import '../../../../shared/providers/auth_provider.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inquiryState = ref.watch(inquiryNotifierProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('고객센터'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 헤더
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // FAQ 섹션
              _buildFAQSection(),
              
              const SizedBox(height: 24),
              
              // 문의하기 섹션
              _buildContactSection(),
              
              const SizedBox(height: 24),
              
              // 연락처 정보
              _buildContactInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '고객센터',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '궁금한 점이 있으시면 언제든 문의해주세요\n24시간 이내에 답변드리겠습니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      FAQItem(
        question: '무료 상담 횟수는 몇 회인가요?',
        answer: '신규 가입자에게는 3회의 무료 상담 기회를 제공합니다. 프리미엄 구독시 무제한으로 이용 가능합니다.',
      ),
      FAQItem(
        question: 'AI 상담사는 어떤 모델을 사용하나요?',
        answer: 'OpenAI GPT-3.5와 Claude 3.5 Sonnet 중에서 선택할 수 있습니다. 각각 다른 특성을 가지고 있어 상황에 맞게 선택하시면 됩니다.',
      ),
      FAQItem(
        question: '구독을 취소하려면 어떻게 해야 하나요?',
        answer: '앱스토어(iOS) 또는 플레이스토어(Android)에서 구독을 취소할 수 있습니다. 다음 결제일 전에 취소하면 자동 갱신이 중단됩니다.',
      ),
      FAQItem(
        question: '채팅 기록이 안전하게 보관되나요?',
        answer: '모든 채팅 기록은 Firebase의 보안 서버에 암호화되어 저장됩니다. 본인만 접근할 수 있으며, 언제든 삭제하실 수 있습니다.',
      ),
      FAQItem(
        question: '계정을 삭제하면 어떻게 되나요?',
        answer: '계정 삭제시 모든 개인정보, 채팅 기록, 구독 정보가 즉시 영구 삭제됩니다. 이 작업은 되돌릴 수 없습니다.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '자주 묻는 질문',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: faqs.asMap().entries.map((entry) {
              final index = entry.key;
              final faq = entry.value;
              return _buildFAQItem(faq, index == faqs.length - 1);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem faq, bool isLast) {
    return ExpansionTile(
      title: Text(
        faq.question,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundStart,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            faq.answer,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1:1 문의하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _messageController,
                  labelText: '문의 내용',
                  hintText: '궁금한 점이나 불편한 점을 자세히 적어주세요...',
                  maxLines: 6,
                  maxLength: 1000,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '문의 내용을 입력해주세요';
                    }
                    if (value.trim().length < 10) {
                      return '문의 내용을 10자 이상 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final inquiryState = ref.watch(inquiryNotifierProvider);
                    return CustomButton(
                      text: '문의하기',
                      onPressed: inquiryState.isLoading ? null : _submitInquiry,
                      isLoading: inquiryState.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '연락처 정보',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email,
            title: '이메일',
            content: 'support@lovecoach.app',
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            icon: Icons.schedule,
            title: '응답 시간',
            content: '평일 09:00 - 18:00\n(24시간 이내 답변)',
            color: AppTheme.calmColor,
          ),
          const SizedBox(height: 12),
          _buildContactItem(
            icon: Icons.language,
            title: '지원 언어',
            content: '한국어',
            color: AppTheme.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인이 필요합니다.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final success = await ref
          .read(inquiryNotifierProvider.notifier)
          .submitInquiry(_messageController.text.trim());

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('문의가 성공적으로 접수되었습니다. 24시간 이내에 답변드리겠습니다. ✅'),
            backgroundColor: AppTheme.calmColor,
            duration: Duration(seconds: 4),
          ),
        );
        _messageController.clear();
        
        // 상태 초기화
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(inquiryNotifierProvider.notifier).resetState();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('문의 접수 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}