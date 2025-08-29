import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
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
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.policy,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '개인정보 처리방침',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '최종 업데이트: 2024.08.24',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // 개인정보 처리방침 내용
                _buildSection(
                  '1. 개인정보의 처리 목적',
                  '러브코치 앱은 다음의 목적을 위하여 개인정보를 처리합니다.\n\n'
                  '• 회원 가입 및 관리\n'
                  '• AI 상담 서비스 제공\n'
                  '• 구독 및 결제 처리\n'
                  '• 고객 지원 서비스\n'
                  '• 서비스 개선 및 분석',
                ),
                
                _buildSection(
                  '2. 개인정보의 처리 및 보유기간',
                  '이용자의 개인정보는 다음과 같이 처리 및 보유됩니다.\n\n'
                  '• 회원정보: 회원 탈퇴시까지\n'
                  '• 채팅 기록: 회원 탈퇴시까지 (사용자 요청시 즉시 삭제)\n'
                  '• 결제 정보: 관계 법령에 따라 5년\n'
                  '• 서비스 이용 기록: 3개월',
                ),
                
                _buildSection(
                  '3. 처리하는 개인정보 항목',
                  '러브코치 앱은 다음의 개인정보 항목을 처리합니다.\n\n'
                  '• 필수항목: 이메일 주소, 비밀번호, 닉네임\n'
                  '• 선택항목: 프로필 이미지\n'
                  '• 자동수집: 접속 로그, 쿠키, 접속 IP정보\n'
                  '• 채팅 데이터: 상담 내용 (암호화 저장)',
                ),
                
                _buildSection(
                  '4. 개인정보의 제3자 제공',
                  '러브코치 앱은 원칙적으로 이용자의 개인정보를 외부에 제공하지 않습니다.\n\n'
                  '다만, 다음의 경우에는 예외로 합니다:\n'
                  '• 이용자들이 사전에 동의한 경우\n'
                  '• 법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우',
                ),
                
                _buildSection(
                  '5. 개인정보 처리 위탁',
                  '러브코치 앱은 서비스 향상을 위해 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.\n\n'
                  '• Firebase (Google): 데이터 저장 및 사용자 인증\n'
                  '• OpenAI/Anthropic: AI 상담 서비스 제공\n'
                  '• Apple/Google: 인앱 결제 처리',
                ),
                
                _buildSection(
                  '6. 이용자의 권리·의무 및 행사방법',
                  '이용자는 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다.\n\n'
                  '• 개인정보 열람 요구\n'
                  '• 오류 등이 있을 경우 정정·삭제 요구\n'
                  '• 처리정지 요구\n'
                  '• 손해배상 청구\n\n'
                  '위 권리 행사는 앱 내 \'계정 관리\' 메뉴에서 직접 처리하거나 고객센터를 통해 요청할 수 있습니다.',
                ),
                
                _buildSection(
                  '7. 개인정보 보호책임자',
                  '러브코치 앱은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n\n'
                  '개인정보 보호책임자\n'
                  '• 성명: 개발팀\n'
                  '• 연락처: support@lovecoach.app\n'
                  '• 이메일: privacy@lovecoach.app',
                ),
                
                const SizedBox(height: 32),
                
                // 연락처 정보
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundStart,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.contact_support,
                        color: AppTheme.accentColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '개인정보 관련 문의',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'privacy@lovecoach.app\n24시간 이내 답변드립니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}