import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../core/theme/app_theme.dart';

class LevelUpDialog extends StatefulWidget {
  final int oldLevel;
  final int newLevel;
  final String oldRank;
  final String newRank;
  final int newExp;

  const LevelUpDialog({
    super.key,
    required this.oldLevel,
    required this.newLevel,
    required this.oldRank,
    required this.newRank,
    required this.newExp,
  });

  static void show(BuildContext context, {
    required int oldLevel,
    required int newLevel,
    required String oldRank,
    required String newRank,
    required int newExp,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LevelUpDialog(
        oldLevel: oldLevel,
        newLevel: newLevel,
        oldRank: oldRank,
        newRank: newRank,
        newExp: newExp,
      ),
    );
  }

  @override
  State<LevelUpDialog> createState() => _LevelUpDialogState();
}

class _LevelUpDialogState extends State<LevelUpDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _sparkleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkleController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _sparkleController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  Color _getRankColor(int level) {
    // Create a temporary UserModel to get color
    final tempUser = UserModel(
      id: '',
      email: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      experiencePoints: _getExpForLevel(level),
    );
    final colors = tempUser.rankColor;
    return Color.fromRGBO(colors['r']!, colors['g']!, colors['b']!, 1.0);
  }

  int _getExpForLevel(int level) {
    if (level == 1) return 0;
    if (level == 2) return 100;
    if (level == 3) return 300;
    if (level == 4) return 600;
    if (level == 5) return 1000;
    if (level == 6) return 1500;
    if (level == 7) return 2100;
    if (level == 8) return 2800;
    if (level == 9) return 3600;
    if (level == 10) return 4500;
    return level * 1000;
  }

  String _getRankEmoji(String rank) {
    switch (rank) {
      case '풋사랑': return '🌱';
      case '설레임': return '💕';
      case '첫키스': return '💋';
      case '달콤한사랑': return '🍯';
      case '열정적사랑': return '🔥';
      case '진실한사랑': return '💖';
      case '운명적사랑': return '✨';
      case '영원한사랑': return '👑';
      case '사랑의전설': return '🏆';
      default: return '💝';
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = _getRankColor(widget.newLevel);
    final rankEmoji = _getRankEmoji(widget.newRank);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          rankColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: rankColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sparkle animation
                        AnimatedBuilder(
                          animation: _sparkleAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _sparkleAnimation.value * 0.7,
                              child: Container(
                                height: 60,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Transform.scale(
                                      scale: 0.5 + (_sparkleAnimation.value * 0.5),
                                      child: const Text('✨', style: TextStyle(fontSize: 20)),
                                    ),
                                    Transform.scale(
                                      scale: 0.3 + (_sparkleAnimation.value * 0.7),
                                      child: const Text('⭐', style: TextStyle(fontSize: 16)),
                                    ),
                                    Transform.scale(
                                      scale: 0.6 + (_sparkleAnimation.value * 0.4),
                                      child: const Text('💫', style: TextStyle(fontSize: 18)),
                                    ),
                                    Transform.scale(
                                      scale: 0.4 + (_sparkleAnimation.value * 0.6),
                                      child: const Text('✨', style: TextStyle(fontSize: 14)),
                                    ),
                                    Transform.scale(
                                      scale: 0.7 + (_sparkleAnimation.value * 0.3),
                                      child: const Text('⭐', style: TextStyle(fontSize: 22)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        // Level Up Title
                        Text(
                          '🎉 LEVEL UP! 🎉',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: rankColor,
                            letterSpacing: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Level progression
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Old level
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Lv.${widget.oldLevel}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            
                            // Arrow
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 30,
                                color: rankColor,
                              ),
                            ),
                            
                            // New level
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [rankColor, rankColor.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: rankColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Lv.${widget.newLevel}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Rank info
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: rankColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: rankColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Rank emoji and name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    rankEmoji,
                                    style: const TextStyle(fontSize: 40),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.newRank,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: rankColor,
                                        ),
                                      ),
                                      Text(
                                        'Lv.${widget.newLevel}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: rankColor.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Experience info
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: rankColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '현재 경험치: ${widget.newExp} EXP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: rankColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Congratulations message
                        Text(
                          '축하합니다! 🎊\n더욱 성장한 당신의 사랑을 응원해요!',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Close button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rankColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              '확인',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}