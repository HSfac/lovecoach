import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('이용약관'),
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
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.article,
                        color: AppTheme.accentColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '서비스 이용약관',
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
                
                // 이용약관 내용
                _buildSection(
                  '제1조 (목적)',
                  '이 약관은 러브코치 앱(이하 "서비스")을 이용함에 있어 회사와 이용자의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.',
                ),
                
                _buildSection(
                  '제2조 (정의)',
                  '1. "서비스"란 러브코치가 제공하는 AI 기반 연애 상담 서비스를 의미합니다.\n'
                  '2. "이용자"란 이 약관에 따라 회사가 제공하는 서비스를 받는 회원 및 비회원을 말합니다.\n'
                  '3. "회원"이란 회사에 개인정보를 제공하여 회원등록을 한 자로서, 회사의 정보를 지속적으로 제공받으며, 회사가 제공하는 서비스를 계속적으로 이용할 수 있는 자를 말합니다.',
                ),
                
                _buildSection(
                  '제3조 (약관의 효력 및 변경)',
                  '1. 이 약관은 서비스를 이용하고자 하는 모든 이용자에 대하여 그 효력을 발생합니다.\n'
                  '2. 회사는 합리적인 사유가 발생할 경우 관련 법령에 위배되지 않는 범위에서 이 약관을 변경할 수 있습니다.\n'
                  '3. 약관이 변경되는 경우 회사는 변경된 약관을 적용하기 최소 7일 전에 앱 내 공지사항을 통해 공지합니다.',
                ),
                
                _buildSection(
                  '제4조 (서비스의 제공)',
                  '1. 회사는 다음과 같은 서비스를 제공합니다:\n'
                  '• AI 기반 연애 상담 서비스\n'
                  '• 카테고리별 맞춤 상담 (썸, 연애중, 이별후, 재회)\n'
                  '• 채팅 기록 관리\n'
                  '• 프리미엄 구독 서비스\n\n'
                  '2. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다. 다만, 시스템 점검 등의 사유로 서비스가 중단될 수 있습니다.',
                ),
                
                _buildSection(
                  '제5조 (회원가입)',
                  '1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.\n'
                  '2. 회원가입은 이메일 인증을 완료한 후에 최종 승인됩니다.\n'
                  '3. 다음에 해당하는 신청에 대하여는 승인을 하지 않을 수 있습니다:\n'
                  '• 타인의 명의를 이용한 경우\n'
                  '• 허위 정보를 기재한 경우\n'
                  '• 사회의 안녕과 질서, 미풍양속을 저해할 목적으로 신청한 경우',
                ),
                
                _buildSection(
                  '제6조 (AI 상담 서비스)',
                  '1. AI 상담 서비스는 인공지능을 기반으로 한 자동 응답 서비스입니다.\n'
                  '2. AI 상담 내용은 참고용이며, 전문적인 심리상담이나 의료 상담을 대체할 수 없습니다.\n'
                  '3. 심각한 정신 건강 문제나 응급 상황의 경우 전문 기관의 도움을 받으시기 바랍니다.\n'
                  '4. 회사는 AI 상담 내용으로 인한 직간접적 손해에 대해 책임을 지지 않습니다.',
                ),
                
                _buildSection(
                  '제7조 (유료 서비스)',
                  '1. 프리미엄 구독 서비스는 월 단위 자동 갱신됩니다.\n'
                  '2. 구독 취소는 언제든지 가능하며, 다음 결제일 전에 취소하면 자동 갱신이 중단됩니다.\n'
                  '3. 환불 정책은 Apple App Store 및 Google Play Store의 정책을 따릅니다.\n'
                  '4. 구독료는 사전 공지 후 변경될 수 있습니다.',
                ),
                
                _buildSection(
                  '제8조 (이용자의 의무)',
                  '1. 이용자는 다음 행위를 하여서는 안 됩니다:\n'
                  '• 타인의 정보 도용\n'
                  '• 서비스의 안정적 운영을 방해하는 행위\n'
                  '• 외설적이거나 폭력적인 내용 전송\n'
                  '• 스팸, 광고성 정보 전송\n'
                  '• 저작권 등 타인의 권리를 침해하는 행위\n\n'
                  '2. 위반 시 서비스 이용이 제한될 수 있습니다.',
                ),
                
                _buildSection(
                  '제9조 (서비스 이용의 제한)',
                  '회사는 이용자가 다음에 해당하는 행위를 하였을 경우 사전 통지 없이 이용계약을 해지하거나 서비스 이용을 제한할 수 있습니다:\n'
                  '• 약관 위반 행위\n'
                  '• 타인에게 피해를 주는 행위\n'
                  '• 서비스의 정상적인 이용을 방해하는 행위\n'
                  '• 관련 법령 위반 행위',
                ),
                
                _buildSection(
                  '제10조 (면책조항)',
                  '1. 회사는 천재지변, 전쟁 및 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 대한 책임이 면제됩니다.\n'
                  '2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.\n'
                  '3. 회사는 이용자가 서비스를 이용하여 기대하는 수익을 얻지 못한 것에 대하여 책임을 지지 않습니다.',
                ),
                
                const SizedBox(height: 32),
                
                // 문의 안내
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.support_agent,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '약관 관련 문의',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'legal@lovecoach.app\n영업일 기준 24시간 이내 답변',
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