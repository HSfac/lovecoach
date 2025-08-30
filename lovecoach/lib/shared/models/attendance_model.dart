import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String userId;
  final DateTime date;
  final bool isCheckedIn;
  final int experienceGained;
  final int currentStreak;
  final DateTime timestamp;

  const AttendanceRecord({
    required this.userId,
    required this.date,
    required this.isCheckedIn,
    this.experienceGained = 0,
    this.currentStreak = 0,
    required this.timestamp,
  });

  factory AttendanceRecord.fromFirestore(Map<String, dynamic> data, String id) {
    return AttendanceRecord(
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      isCheckedIn: data['isCheckedIn'] ?? false,
      experienceGained: data['experienceGained'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'isCheckedIn': isCheckedIn,
      'experienceGained': experienceGained,
      'currentStreak': currentStreak,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  String get dateKey => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  AttendanceRecord copyWith({
    String? userId,
    DateTime? date,
    bool? isCheckedIn,
    int? experienceGained,
    int? currentStreak,
    DateTime? timestamp,
  }) {
    return AttendanceRecord(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      experienceGained: experienceGained ?? this.experienceGained,
      currentStreak: currentStreak ?? this.currentStreak,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class UserAttendanceStats {
  final String userId;
  final int totalCheckIns;
  final int currentStreak;
  final int maxStreak;
  final DateTime? lastCheckIn;
  final int totalExperienceGained;
  final Map<String, bool> monthlyAttendance; // dateKey -> isCheckedIn

  const UserAttendanceStats({
    required this.userId,
    this.totalCheckIns = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.lastCheckIn,
    this.totalExperienceGained = 0,
    this.monthlyAttendance = const {},
  });

  factory UserAttendanceStats.fromFirestore(Map<String, dynamic> data, String id) {
    return UserAttendanceStats(
      userId: id,
      totalCheckIns: data['totalCheckIns'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      maxStreak: data['maxStreak'] ?? 0,
      lastCheckIn: data['lastCheckIn'] != null 
          ? (data['lastCheckIn'] as Timestamp).toDate() 
          : null,
      totalExperienceGained: data['totalExperienceGained'] ?? 0,
      monthlyAttendance: Map<String, bool>.from(data['monthlyAttendance'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCheckIns': totalCheckIns,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'lastCheckIn': lastCheckIn != null ? Timestamp.fromDate(lastCheckIn!) : null,
      'totalExperienceGained': totalExperienceGained,
      'monthlyAttendance': monthlyAttendance,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool isCheckedInToday() {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return monthlyAttendance[todayKey] ?? false;
  }

  bool wasYesterdayCheckedIn() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
    return monthlyAttendance[yesterdayKey] ?? false;
  }

  UserAttendanceStats copyWith({
    String? userId,
    int? totalCheckIns,
    int? currentStreak,
    int? maxStreak,
    DateTime? lastCheckIn,
    int? totalExperienceGained,
    Map<String, bool>? monthlyAttendance,
  }) {
    return UserAttendanceStats(
      userId: userId ?? this.userId,
      totalCheckIns: totalCheckIns ?? this.totalCheckIns,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalExperienceGained: totalExperienceGained ?? this.totalExperienceGained,
      monthlyAttendance: monthlyAttendance ?? this.monthlyAttendance,
    );
  }
}

// Attendance rewards configuration
class AttendanceReward {
  final int streakDays;
  final int experienceBonus;
  final String title;
  final String description;
  final String emoji;

  const AttendanceReward({
    required this.streakDays,
    required this.experienceBonus,
    required this.title,
    required this.description,
    required this.emoji,
  });

  static const List<AttendanceReward> rewards = [
    AttendanceReward(
      streakDays: 1,
      experienceBonus: 5,
      title: '첫 출석',
      description: '매일 출석으로 기본 경험치를 받아요',
      emoji: '📅',
    ),
    AttendanceReward(
      streakDays: 3,
      experienceBonus: 15,
      title: '꾸준한 마음',
      description: '3일 연속 출석 보너스!',
      emoji: '🔥',
    ),
    AttendanceReward(
      streakDays: 7,
      experienceBonus: 35,
      title: '일주일 달성',
      description: '7일 연속, 정말 대단해요!',
      emoji: '⭐',
    ),
    AttendanceReward(
      streakDays: 14,
      experienceBonus: 70,
      title: '2주 마스터',
      description: '2주 연속 출석의 달인!',
      emoji: '🏆',
    ),
    AttendanceReward(
      streakDays: 30,
      experienceBonus: 150,
      title: '한 달 전설',
      description: '30일 연속, 당신은 전설입니다!',
      emoji: '👑',
    ),
  ];

  static AttendanceReward? getRewardForStreak(int streak) {
    for (final reward in rewards.reversed) {
      if (streak >= reward.streakDays) {
        return reward;
      }
    }
    return null;
  }

  static int getExperienceForStreak(int streak) {
    final reward = getRewardForStreak(streak);
    return reward?.experienceBonus ?? 5; // Default 5 EXP
  }
}