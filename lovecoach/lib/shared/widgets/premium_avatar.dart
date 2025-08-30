import 'package:flutter/material.dart';
import '../models/user_model.dart';

// Unified Level System Helper
class UserLevelHelper {
  // Get rank color based on user level
  static Color getRankColor(UserModel user) {
    final colors = user.rankColor;
    return Color.fromRGBO(colors['r']!, colors['g']!, colors['b']!, 1.0);
  }
  
  // Get rank icon based on user level  
  static IconData getRankIcon(UserModel user) {
    final level = user.userLevel;
    if (level == 1) return Icons.eco_outlined; // 새싹
    if (level <= 3) return Icons.favorite_outline; // 설레임
    if (level <= 5) return Icons.favorite; // 첫키스
    if (level <= 7) return Icons.cake; // 달콤한사랑
    if (level <= 10) return Icons.local_fire_department; // 열정적사랑
    if (level <= 15) return Icons.favorite_rounded; // 진실한사랑
    if (level <= 25) return Icons.auto_awesome; // 운명적사랑
    if (level <= 35) return Icons.workspace_premium; // 영원한사랑
    return Icons.emoji_events; // 사랑의전설
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
    
    // Use unified level system
    final rankColor = user != null 
        ? UserLevelHelper.getRankColor(user!)
        : Colors.grey;
    final rankIcon = user != null
        ? UserLevelHelper.getRankIcon(user!)
        : Icons.eco_outlined;

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
                  backgroundColor: rankColor.withOpacity(0.15),
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                  child: photoUrl == null
                      ? Text(
                          displayName.isNotEmpty ? displayName[0] : '?',
                          style: TextStyle(
                            fontSize: radius * 0.7,
                            fontWeight: FontWeight.bold,
                            color: rankColor,
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
                color: rankColor,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: rankColor.withOpacity(0.15),
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
              child: photoUrl == null
                  ? Text(
                      displayName.isNotEmpty ? displayName[0] : '?',
                      style: TextStyle(
                        fontSize: radius * 0.7,
                        fontWeight: FontWeight.bold,
                        color: rankColor,
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
                color: rankColor,
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
                rankIcon,
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

// Rank Display Widget (Using unified level system)
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
    // Use unified level system
    final rankColor = UserLevelHelper.getRankColor(user);
    final rankIcon = UserLevelHelper.getRankIcon(user);
    final userLevel = user.userLevel;
    final userRank = user.userRank;
    final currentExp = user.experiencePoints;
    final expForNext = user.expForNextLevel;
    final expNeeded = expForNext - currentExp;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: rankColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rankColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            rankIcon,
            size: 14,
            color: rankColor,
          ),
          const SizedBox(width: 4),
          Text(
            'Lv.$userLevel',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: rankColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            userRank,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: rankColor,
            ),
          ),
          if (showProgress && expNeeded > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(+$expNeeded)',
              style: TextStyle(
                fontSize: 10,
                color: rankColor.withOpacity(0.7),
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