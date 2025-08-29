import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/chat_message.dart';
import '../models/ai_model.dart';

class CounselorProfile extends StatelessWidget {
  final ConsultationCategory category;
  final AIModel? aiModel;

  const CounselorProfile({
    super.key, 
    required this.category,
    this.aiModel,
  });

  @override
  Widget build(BuildContext context) {
    final counselorInfo = _getCounselorInfo(category);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.backgroundStart,
            AppTheme.backgroundEnd,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 상담사 아바타
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  counselorInfo.primaryColor,
                  counselorInfo.primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: counselorInfo.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              counselorInfo.icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // 상담사 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      counselorInfo.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.calmColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '온라인',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  counselorInfo.specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppTheme.happyColor,
                      size: 16,
                    ),
                    Text(
                      ' ${counselorInfo.rating} • ${counselorInfo.experience}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 감정 상태 인디케이터
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppTheme.calmColor,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.calmColor.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '집중중',
                style: TextStyle(
                  fontSize: 10,
                  color: AppTheme.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CounselorInfo _getCounselorInfo(ConsultationCategory category) {
    switch (category) {
      case ConsultationCategory.flirting:
        return CounselorInfo(
          name: '하트 코치',
          specialty: '썸&첫만남 전문 AI 상담사',
          rating: '4.9',
          experience: 'AI 전문가',
          icon: Icons.favorite_border,
          primaryColor: AppTheme.primaryColor,
        );
      case ConsultationCategory.dating:
        return CounselorInfo(
          name: '러브 닥터',
          specialty: '연애 관계 전문 AI 상담사',
          rating: '4.8',
          experience: 'AI 전문가',
          icon: Icons.favorite,
          primaryColor: Colors.red[400]!,
        );
      case ConsultationCategory.breakup:
        return CounselorInfo(
          name: '힐링 메이트',
          specialty: '이별 상처 치유 AI 전문가',
          rating: '4.9',
          experience: 'AI 전문가',
          icon: Icons.healing,
          primaryColor: AppTheme.sadColor,
        );
      case ConsultationCategory.reconciliation:
        return CounselorInfo(
          name: '리뉴 코치',
          specialty: '관계 회복 전문 AI 상담사',
          rating: '4.7',
          experience: 'AI 전문가',
          icon: Icons.refresh,
          primaryColor: AppTheme.calmColor,
        );
    }
  }
}

class CounselorInfo {
  final String name;
  final String specialty;
  final String rating;
  final String experience;
  final IconData icon;
  final Color primaryColor;

  CounselorInfo({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experience,
    required this.icon,
    required this.primaryColor,
  });
}