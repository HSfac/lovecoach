import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class RankGuideScreen extends StatelessWidget {
  const RankGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
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
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildIntroCard(),
                      const SizedBox(height: 24),
                      _buildRankList(),
                      const SizedBox(height: 24),
                      _buildExpGuideCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '💝 사랑의 등급표',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.pink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '등급 시스템 소개',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '연애 상담을 통해 경험치를 쌓으면 등급이 올라가요!\n각 등급마다 특별한 의미와 혜택이 있어요.',
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

  Widget _buildRankList() {
    final ranks = [
      {'level': '1', 'name': '풋사랑', 'exp': '0-99', 'emoji': '🌱', 'desc': '연애의 첫걸음을 내딛는 단계', 'color': [156, 204, 101]},
      {'level': '2-3', 'name': '설레임', 'exp': '100-299', 'emoji': '💕', 'desc': '마음이 두근거리며 설레는 단계', 'color': [255, 182, 193]},
      {'level': '4-5', 'name': '첫키스', 'exp': '300-599', 'emoji': '💋', 'desc': '달콤한 로맨스를 경험하는 단계', 'color': [255, 105, 180]},
      {'level': '6-7', 'name': '달콤한사랑', 'exp': '600-999', 'emoji': '🍯', 'desc': '사랑의 달콤함을 만끽하는 단계', 'color': [255, 69, 0]},
      {'level': '8-10', 'name': '열정적사랑', 'exp': '1000-1499', 'emoji': '🔥', 'desc': '열정적인 사랑에 빠진 단계', 'color': [220, 20, 60]},
      {'level': '11-15', 'name': '진실한사랑', 'exp': '1500-2099', 'emoji': '💖', 'desc': '진실하고 깊은 사랑을 아는 단계', 'color': [128, 0, 128]},
      {'level': '16-25', 'name': '운명적사랑', 'exp': '2100-2799', 'emoji': '✨', 'desc': '운명적인 만남을 믿는 단계', 'color': [75, 0, 130]},
      {'level': '26-35', 'name': '영원한사랑', 'exp': '2800+', 'emoji': '👑', 'desc': '영원한 사랑의 가치를 아는 단계', 'color': [255, 215, 0]},
      {'level': '36+', 'name': '사랑의전설', 'exp': '5000+', 'emoji': '🏆', 'desc': '사랑의 모든 것을 아는 전설적인 단계', 'color': [255, 20, 147]},
    ];

    return Column(
      children: ranks.map((rank) => _buildRankCard(rank)).toList(),
    );
  }

  Widget _buildRankCard(Map<String, dynamic> rank) {
    final colorList = rank['color'] as List<int>;
    final rankColor = Color.fromRGBO(colorList[0], colorList[1], colorList[2], 1.0);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rankColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  rankColor,
                  rankColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                rank['emoji'],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Lv.${rank['level']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: rankColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: rankColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rank['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rankColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rank['desc'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '필요 경험치: ${rank['exp']} EXP',
                  style: TextStyle(
                    fontSize: 11,
                    color: rankColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpGuideCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '경험치 획득 방법',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildExpItem('💬', '기본 상담', '+20 EXP', '매번 상담할 때마다'),
          const SizedBox(height: 8),
          _buildExpItem('🔥', '연속 접속', '+5 EXP', '연속으로 접속할 때마다'),
          const SizedBox(height: 8),
          _buildExpItem('⭐', '주간 보너스', '+30 EXP', '7일 연속 접속 달성'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '꾸준히 상담하면 더 많은 경험치를 얻을 수 있어요!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpItem(String emoji, String title, String exp, String desc) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            exp,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}