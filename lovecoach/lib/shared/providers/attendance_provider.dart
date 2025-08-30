import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_model.dart';
import '../services/attendance_service.dart';
import 'auth_provider.dart';

// Attendance service provider
final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService();
});

// User attendance stats stream
final userAttendanceStatsProvider = StreamProvider<UserAttendanceStats>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value(const UserAttendanceStats(userId: ''));
  }
  
  final attendanceService = ref.watch(attendanceServiceProvider);
  return attendanceService.getUserAttendanceStats(user.uid);
});

// Can check in today provider
final canCheckInTodayProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  
  final attendanceService = ref.watch(attendanceServiceProvider);
  return attendanceService.canCheckInToday(user.uid);
});

// Monthly attendance records provider
final monthlyAttendanceProvider = FutureProvider.family<List<AttendanceRecord>, DateTime>((ref, month) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];
  
  final attendanceService = ref.watch(attendanceServiceProvider);
  return attendanceService.getMonthlyAttendance(user.uid, month);
});

// Attendance statistics provider
final attendanceStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return {
      'totalDays': 0,
      'currentStreak': 0,
      'maxStreak': 0,
      'thisMonthDays': 0,
      'totalExperience': 0,
    };
  }
  
  final attendanceService = ref.watch(attendanceServiceProvider);
  return attendanceService.getAttendanceStatistics(user.uid);
});

// Check-in action provider
final checkInActionProvider = Provider<Future<AttendanceCheckInResult> Function()>((ref) {
  return () async {
    final user = ref.read(authStateProvider).value;
    if (user == null) {
      return const AttendanceCheckInResult(
        success: false,
        message: '로그인이 필요해요',
        experienceGained: 0,
        newStreak: 0,
      );
    }
    
    final attendanceService = ref.read(attendanceServiceProvider);
    final result = await attendanceService.checkInToday(user.uid);
    
    // Refresh providers after check-in
    if (result.success) {
      ref.invalidate(userAttendanceStatsProvider);
      ref.invalidate(canCheckInTodayProvider);
      ref.invalidate(attendanceStatisticsProvider);
    }
    
    return result;
  };
});