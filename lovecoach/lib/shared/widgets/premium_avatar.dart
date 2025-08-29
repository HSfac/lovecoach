import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Community Rank System
enum CommunityRank {
  newbie,
  bronze,
  silver,
  gold,
  platinum,
  diamond,
  master,
}

class CommunityRankInfo {
  final String title;
  final String koreanTitle;
  final Color color;
  final IconData icon;
  final int minPoints;

  const CommunityRankInfo({
    required this.title,
    required this.koreanTitle,
    required this.color,
    required this.icon,
    required this.minPoints,
  });
}

class RankSystem {
  static const Map<CommunityRank, CommunityRankInfo> rankInfo = {
    CommunityRank.newbie: CommunityRankInfo(
      title: 'newbie',
      koreanTitle: '새싹',
      color: Colors.grey,
      icon: Icons.eco_outlined,
      minPoints: 0,
    ),
    CommunityRank.bronze: CommunityRankInfo(
      title: 'bronze',
      koreanTitle: '브론즈',
      color: Color(0xFFCD7F32),
      icon: Icons.shield_outlined,
      minPoints: 50,
    ),
    CommunityRank.silver: CommunityRankInfo(
      title: 'silver',
      koreanTitle: '실버',
      color: Color(0xFFC0C0C0),
      icon: Icons.star_border,
      minPoints: 150,
    ),
    CommunityRank.gold: CommunityRankInfo(
      title: 'gold',
      koreanTitle: '골드',
      color: Color(0xFFFFD700),
      icon: Icons.star,
      minPoints: 300,
    ),
    CommunityRank.platinum: CommunityRankInfo(
      title: 'platinum',
      koreanTitle: '플래티넘',
      color: Color(0xFFE5E4E2),
      icon: Icons.military_tech,
      minPoints: 500,
    ),
    CommunityRank.diamond: CommunityRankInfo(
      title: 'diamond',
      koreanTitle: '다이아몬드',
      color: Color(0xFFB9F2FF),
      icon: Icons.diamond,
      minPoints: 800,
    ),
    CommunityRank.master: CommunityRankInfo(
      title: 'master',
      koreanTitle: '마스터',
      color: Color(0xFF9400D3),
      icon: Icons.workspace_premium,
      minPoints: 1200,
    ),
  };

  static CommunityRank calculateRank(UserModel user) {
    final points = _calculatePoints(user);
    
    for (final rank in CommunityRank.values.reversed) {
      if (points >= rankInfo[rank]!.minPoints) {
        return rank;
      }
    }
    return CommunityRank.newbie;
  }

  static int _calculatePoints(UserModel user) {
    return (user.communityPostCount * 10) +
           (user.communityCommentCount * 5) +
           (user.communityLikeReceived * 2) +
           (user.communityLikeGiven * 1);
  }

  static CommunityRankInfo getRankInfo(String rankString) {
    final rank = CommunityRank.values.firstWhere(
      (r) => r.toString().split('.').last == rankString,
      orElse: () => CommunityRank.newbie,
    );
    return rankInfo[rank]!;
  }

  static int getUserPoints(UserModel user) => _calculatePoints(user);
  
  static int getPointsToNextRank(UserModel user) {
    final currentRank = calculateRank(user);
    final currentPoints = _calculatePoints(user);
    
    final currentIndex = CommunityRank.values.indexOf(currentRank);
    if (currentIndex >= CommunityRank.values.length - 1) {
      return 0; // Already at max rank
    }
    
    final nextRank = CommunityRank.values[currentIndex + 1];
    return rankInfo[nextRank]!.minPoints - currentPoints;
  }
}

// Premium Avatar Widget
class PremiumAvatar extends StatelessWidget {
  final UserModel? user;
  final String displayName;
  final double radius;
  final bool showRankBadge;
  final String? photoUrl;

  const PremiumAvatar({
    super.key,
    this.user,
    required this.displayName,
    this.radius = 20,
    this.showRankBadge = true,
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isSubscribed = user?.isSubscribed ?? false;
    final rankInfo = user != null 
        ? RankSystem.getRankInfo(user!.communityRank)
        : RankSystem.rankInfo[CommunityRank.newbie]!;

    return Stack(
      children: [
        // Premium border animation for subscribers
        if (isSubscribed)
          Container(
            width: (radius + 4) * 2,
            height: (radius + 4) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.orange,
                  Colors.red,
                  Colors.purple,
                ],
                stops: [0.0, 0.16, 0.33, 0.5, 0.66, 0.83, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: CircleAvatar(
                radius: radius,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: radius - 2,
                  backgroundColor: rankInfo.color.withOpacity(0.15),
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                  child: photoUrl == null
                      ? Text(
                          displayName.isNotEmpty ? displayName[0] : '?',
                          style: TextStyle(
                            fontSize: radius * 0.7,
                            fontWeight: FontWeight.bold,
                            color: rankInfo.color,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          )
        else
          // Regular border with rank color
          Container(
            width: (radius + 2) * 2,
            height: (radius + 2) * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: rankInfo.color,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: rankInfo.color.withOpacity(0.15),
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
              child: photoUrl == null
                  ? Text(
                      displayName.isNotEmpty ? displayName[0] : '?',
                      style: TextStyle(
                        fontSize: radius * 0.7,
                        fontWeight: FontWeight.bold,
                        color: rankInfo.color,
                      ),
                    )
                  : null,
            ),
          ),

        // Rank badge
        if (showRankBadge)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: rankInfo.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                rankInfo.icon,
                size: radius * 0.4,
                color: Colors.white,
              ),
            ),
          ),

        // Premium crown for subscribers
        if (isSubscribed)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.workspace_premium,
                size: radius * 0.3,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

// Rank Display Widget
class RankDisplay extends StatelessWidget {
  final UserModel user;
  final bool showProgress;

  const RankDisplay({
    super.key,
    required this.user,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    final rankInfo = RankSystem.getRankInfo(user.communityRank);
    final currentPoints = RankSystem.getUserPoints(user);
    final pointsToNext = RankSystem.getPointsToNextRank(user);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: rankInfo.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rankInfo.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            rankInfo.icon,
            size: 14,
            color: rankInfo.color,
          ),
          const SizedBox(width: 4),
          Text(
            rankInfo.koreanTitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: rankInfo.color,
            ),
          ),
          if (showProgress && pointsToNext > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(+$pointsToNext)',
              style: TextStyle(
                fontSize: 10,
                color: rankInfo.color.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Premium Badge Widget
class PremiumBadge extends StatelessWidget {
  final bool isSubscribed;

  const PremiumBadge({
    super.key,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSubscribed) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium,
            size: 10,
            color: Colors.white,
          ),
          SizedBox(width: 2),
          Text(
            'PRO',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}