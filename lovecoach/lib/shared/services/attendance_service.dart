import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance_model.dart';
import '../models/user_model.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user attendance stats
  Stream<UserAttendanceStats> getUserAttendanceStats(String userId) {
    return _firestore
        .collection('attendance_stats')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserAttendanceStats.fromFirestore(doc.data()!, doc.id);
      } else {
        return UserAttendanceStats(userId: userId);
      }
    });
  }

  // Get monthly attendance records
  Future<List<AttendanceRecord>> getMonthlyAttendance(String userId, DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final snapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    return snapshot.docs
        .map((doc) => AttendanceRecord.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Check if user can check in today
  Future<bool> canCheckInToday(String userId) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('attendance')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .where('isCheckedIn', isEqualTo: true)
        .limit(1)
        .get();

    return snapshot.docs.isEmpty;
  }

  // Perform daily check-in
  Future<AttendanceCheckInResult> checkInToday(String userId) async {
    final canCheckIn = await canCheckInToday(userId);
    if (!canCheckIn) {
      return AttendanceCheckInResult(
        success: false,
        message: '오늘은 이미 출석체크를 완료했어요!',
        experienceGained: 0,
        newStreak: 0,
      );
    }

    try {
      return await _firestore.runTransaction((transaction) async {
        // Get current user stats
        final statsRef = _firestore.collection('attendance_stats').doc(userId);
        final statsDoc = await transaction.get(statsRef);
        
        UserAttendanceStats currentStats;
        if (statsDoc.exists) {
          currentStats = UserAttendanceStats.fromFirestore(statsDoc.data()!, statsDoc.id);
        } else {
          currentStats = UserAttendanceStats(userId: userId);
        }

        // Calculate new streak
        int newStreak;
        if (currentStats.wasYesterdayCheckedIn() || currentStats.currentStreak == 0) {
          newStreak = currentStats.currentStreak + 1;
        } else {
          // Streak was broken
          newStreak = 1;
        }

        // Calculate experience reward
        final experienceGained = AttendanceReward.getExperienceForStreak(newStreak);
        
        // Create attendance record
        final today = DateTime.now();
        final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        
        final attendanceRecord = AttendanceRecord(
          userId: userId,
          date: DateTime(today.year, today.month, today.day),
          isCheckedIn: true,
          experienceGained: experienceGained,
          currentStreak: newStreak,
          timestamp: DateTime.now(),
        );

        // Update monthly attendance map
        final updatedMonthlyAttendance = Map<String, bool>.from(currentStats.monthlyAttendance);
        updatedMonthlyAttendance[todayKey] = true;

        // Update user stats
        final updatedStats = currentStats.copyWith(
          totalCheckIns: currentStats.totalCheckIns + 1,
          currentStreak: newStreak,
          maxStreak: newStreak > currentStats.maxStreak ? newStreak : currentStats.maxStreak,
          lastCheckIn: DateTime.now(),
          totalExperienceGained: currentStats.totalExperienceGained + experienceGained,
          monthlyAttendance: updatedMonthlyAttendance,
        );

        // Save to Firestore
        final attendanceRef = _firestore.collection('attendance').doc();
        transaction.set(attendanceRef, attendanceRecord.toFirestore());
        transaction.set(statsRef, updatedStats.toFirestore());

        // Update user experience points
        final userRef = _firestore.collection('users').doc(userId);
        final userDoc = await transaction.get(userRef);
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final currentExp = userData['experiencePoints'] as int? ?? 0;
          final newExp = currentExp + experienceGained;
          
          // Check for level up
          final oldLevel = _calculateLevel(currentExp);
          final newLevel = _calculateLevel(newExp);
          
          transaction.update(userRef, {
            'experiencePoints': newExp,
            'consecutiveDays': newStreak, // Update consecutive days for compatibility
            'updatedAt': FieldValue.serverTimestamp(),
          });

          // Create level up notification if needed
          if (newLevel > oldLevel) {
            await _createLevelUpNotification(userId, oldLevel, newLevel, newExp);
          }
        }

        // Check for streak milestone rewards
        final rewardAchieved = _checkStreakMilestone(newStreak);

        return AttendanceCheckInResult(
          success: true,
          message: newStreak == 1 
              ? '출석체크 완료! +${experienceGained} EXP'
              : '${newStreak}일 연속 출석! +${experienceGained} EXP',
          experienceGained: experienceGained,
          newStreak: newStreak,
          rewardAchieved: rewardAchieved,
        );
      });
    } catch (e) {
      return AttendanceCheckInResult(
        success: false,
        message: '출석체크 중 오류가 발생했어요: $e',
        experienceGained: 0,
        newStreak: 0,
      );
    }
  }

  // Calculate user level from experience points
  int _calculateLevel(int experiencePoints) {
    if (experiencePoints < 100) return 1;
    if (experiencePoints < 300) return 2;
    if (experiencePoints < 600) return 3;
    if (experiencePoints < 1000) return 4;
    if (experiencePoints < 1500) return 5;
    if (experiencePoints < 2100) return 6;
    if (experiencePoints < 2800) return 7;
    if (experiencePoints < 3600) return 8;
    if (experiencePoints < 4500) return 9;
    if (experiencePoints < 5500) return 10;
    return (experiencePoints ~/ 1000).clamp(10, 50);
  }

  // Get rank name from level
  String _getRankFromLevel(int level) {
    if (level == 1) return '풋사랑';
    if (level <= 3) return '설레임';
    if (level <= 5) return '첫키스';
    if (level <= 7) return '달콤한사랑';
    if (level <= 10) return '열정적사랑';
    if (level <= 15) return '진실한사랑';
    if (level <= 25) return '운명적사랑';
    if (level <= 35) return '영원한사랑';
    return '사랑의전설';
  }

  // Create level up notification
  Future<void> _createLevelUpNotification(String userId, int oldLevel, int newLevel, int newExp) async {
    final oldRank = _getRankFromLevel(oldLevel);
    final newRank = _getRankFromLevel(newLevel);
    
    await _firestore.collection('notifications').add({
      'userId': userId,
      'title': '🎉 레벨 업!',
      'message': '출석체크로 Lv.$newLevel $newRank 등급이 되었어요! 현재 경험치: $newExp EXP',
      'type': 'level_up',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'data': {
        'oldLevel': oldLevel,
        'newLevel': newLevel,
        'oldRank': oldRank,
        'newRank': newRank,
        'newExp': newExp,
        'source': 'attendance',
      },
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Check if streak milestone is achieved
  AttendanceReward? _checkStreakMilestone(int streak) {
    final milestones = [3, 7, 14, 30];
    if (milestones.contains(streak)) {
      return AttendanceReward.getRewardForStreak(streak);
    }
    return null;
  }

  // Get attendance statistics for a user
  Future<Map<String, dynamic>> getAttendanceStatistics(String userId) async {
    final statsDoc = await _firestore.collection('attendance_stats').doc(userId).get();
    
    if (!statsDoc.exists) {
      return {
        'totalDays': 0,
        'currentStreak': 0,
        'maxStreak': 0,
        'thisMonthDays': 0,
        'totalExperience': 0,
      };
    }

    final stats = UserAttendanceStats.fromFirestore(statsDoc.data()!, statsDoc.id);
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    
    // Count this month's check-ins
    int thisMonthDays = 0;
    for (int day = 1; day <= now.day; day++) {
      final dateKey = '${thisMonth.year}-${thisMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      if (stats.monthlyAttendance[dateKey] == true) {
        thisMonthDays++;
      }
    }

    return {
      'totalDays': stats.totalCheckIns,
      'currentStreak': stats.currentStreak,
      'maxStreak': stats.maxStreak,
      'thisMonthDays': thisMonthDays,
      'totalExperience': stats.totalExperienceGained,
    };
  }
}

// Result class for check-in operation
class AttendanceCheckInResult {
  final bool success;
  final String message;
  final int experienceGained;
  final int newStreak;
  final AttendanceReward? rewardAchieved;

  const AttendanceCheckInResult({
    required this.success,
    required this.message,
    required this.experienceGained,
    required this.newStreak,
    this.rewardAchieved,
  });
}