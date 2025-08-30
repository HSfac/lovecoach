import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/providers/attendance_provider.dart';
import '../../../../shared/widgets/attendance_calendar.dart';
import '../../../../shared/widgets/level_up_dialog.dart';
import '../../../../shared/models/attendance_model.dart';
import '../../../../shared/services/attendance_service.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> 
    with TickerProviderStateMixin {
  DateTime _currentMonth = DateTime.now();
  late AnimationController _checkInButtonController;
  late Animation<double> _checkInButtonAnimation;
  bool _isCheckingIn = false;

  @override
  void initState() {
    super.initState();
    _checkInButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _checkInButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _checkInButtonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _checkInButtonController.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  Future<void> _performCheckIn() async {
    if (_isCheckingIn) return;

    setState(() {
      _isCheckingIn = true;
    });

    _checkInButtonController.forward();

    try {
      final checkInAction = ref.read(checkInActionProvider);
      final result = await checkInAction();

      _checkInButtonController.reverse();

      if (result.success) {
        // Show success animation
        _showCheckInSuccess(result);

        // Show level up dialog if there was a level up notification
        // This is handled by the notification system
      } else {
        _showCheckInError(result.message);
      }
    } catch (e) {
      _checkInButtonController.reverse();
      _showCheckInError('출석체크 중 오류가 발생했어요');
    } finally {
      setState(() {
        _isCheckingIn = false;
      });
    }
  }

  void _showCheckInSuccess(AttendanceCheckInResult result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '출석체크 완료! 🎉',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      result.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (result.rewardAchieved != null)
                      Text(
                        '${result.rewardAchieved!.emoji} ${result.rewardAchieved!.title} 달성!',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 4),
      ),
    );

    // Show milestone achievement dialog if applicable
    if (result.rewardAchieved != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _showMilestoneDialog(result.rewardAchieved!);
      });
    }
  }

  void _showMilestoneDialog(AttendanceReward reward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.orange[50]!,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reward.emoji,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 16),
              Text(
                '🎊 축하합니다! 🎊',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                reward.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                reward.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '보너스: +${reward.experienceBonus} EXP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
      ),
    );
  }

  void _showCheckInError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.orange[700],
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange[50],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendanceStats = ref.watch(userAttendanceStatsProvider);
    final canCheckIn = ref.watch(canCheckInTodayProvider);
    final statistics = ref.watch(attendanceStatisticsProvider);

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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Check-in button
                      _buildCheckInButton(canCheckIn),
                      const SizedBox(height: 24),
                      
                      // Streak display
                      attendanceStats.when(
                        data: (stats) => StreakDisplay(
                          currentStreak: stats.currentStreak,
                          maxStreak: stats.maxStreak,
                          animate: true,
                        ),
                        loading: () => const StreakDisplay(
                          currentStreak: 0,
                          maxStreak: 0,
                        ),
                        error: (_, __) => const StreakDisplay(
                          currentStreak: 0,
                          maxStreak: 0,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Statistics cards
                      statistics.when(
                        data: (stats) => AttendanceStatsCards(stats: stats),
                        loading: () => const AttendanceStatsCards(
                          stats: {
                            'totalDays': 0,
                            'currentStreak': 0,
                            'maxStreak': 0,
                            'thisMonthDays': 0,
                            'totalExperience': 0,
                          },
                        ),
                        error: (_, __) => const AttendanceStatsCards(
                          stats: {
                            'totalDays': 0,
                            'currentStreak': 0,
                            'maxStreak': 0,
                            'thisMonthDays': 0,
                            'totalExperience': 0,
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Calendar
                      attendanceStats.when(
                        data: (stats) => AttendanceCalendar(
                          currentMonth: _currentMonth,
                          attendanceStats: stats,
                          onPrevMonth: _previousMonth,
                          onNextMonth: _nextMonth,
                        ),
                        loading: () => AttendanceCalendar(
                          currentMonth: _currentMonth,
                          attendanceStats: const UserAttendanceStats(userId: ''),
                          onPrevMonth: _previousMonth,
                          onNextMonth: _nextMonth,
                        ),
                        error: (_, __) => AttendanceCalendar(
                          currentMonth: _currentMonth,
                          attendanceStats: const UserAttendanceStats(userId: ''),
                          onPrevMonth: _previousMonth,
                          onNextMonth: _nextMonth,
                        ),
                      ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📅 출석체크',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                '매일 출석하고 경험치를 받아요!',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton(AsyncValue<bool> canCheckIn) {
    return canCheckIn.when(
      data: (canCheck) => AnimatedBuilder(
        animation: _checkInButtonAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _checkInButtonAnimation.value,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: canCheck
                      ? [AppTheme.primaryColor, AppTheme.accentColor]
                      : [Colors.grey[400]!, Colors.grey[500]!],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: (canCheck ? AppTheme.primaryColor : Colors.grey)
                        .withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canCheck && !_isCheckingIn ? _performCheckIn : null,
                  borderRadius: BorderRadius.circular(25),
                  child: Center(
                    child: _isCheckingIn
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                canCheck ? Icons.check_circle : Icons.check_circle_outline,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                canCheck ? '출석체크 하기' : '오늘은 출석 완료!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      loading: () => Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Center(
          child: Text('로딩 중...'),
        ),
      ),
    );
  }
}