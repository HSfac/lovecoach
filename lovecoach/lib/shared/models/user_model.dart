class UserModel {
  final String id;
  final String email;
  final bool emailVerified;
  final String? displayName;
  final String? photoUrl;
  final int freeConsultationsUsed;
  final int freeConsultationsLimit;
  final DateTime? lastConsultationDate;
  final int dailyConsultationsUsed;
  final int dailyConsultationsLimit;
  final bool isSubscribed;
  final bool hasCompletedSurvey;
  final DateTime? subscriptionEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Community activity fields
  final int communityPostCount;
  final int communityCommentCount;
  final int communityLikeReceived;
  final int communityLikeGiven;
  final String communityRank;
  
  // User level system
  final int totalConsultations;
  final int consecutiveDays;
  final int currentStreak;
  final DateTime? lastActiveDate;
  final int experiencePoints;

  const UserModel({
    required this.id,
    required this.email,
    this.emailVerified = false,
    this.displayName,
    this.photoUrl,
    this.freeConsultationsUsed = 0,
    this.freeConsultationsLimit = 5,
    this.lastConsultationDate,
    this.dailyConsultationsUsed = 0,
    this.dailyConsultationsLimit = 5,
    this.isSubscribed = false,
    this.hasCompletedSurvey = false,
    this.subscriptionEndDate,
    required this.createdAt,
    required this.updatedAt,
    this.communityPostCount = 0,
    this.communityCommentCount = 0,
    this.communityLikeReceived = 0,
    this.communityLikeGiven = 0,
    this.communityRank = 'newbie',
    this.totalConsultations = 0,
    this.consecutiveDays = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
    this.experiencePoints = 0,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      emailVerified: data['emailVerified'] ?? false,
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      freeConsultationsUsed: data['freeConsultationsUsed'] ?? 0,
      freeConsultationsLimit: data['freeConsultationsLimit'] ?? 5,
      lastConsultationDate: data['lastConsultationDate']?.toDate(),
      dailyConsultationsUsed: data['dailyConsultationsUsed'] ?? 0,
      dailyConsultationsLimit: data['dailyConsultationsLimit'] ?? 5,
      isSubscribed: data['isSubscribed'] ?? false,
      hasCompletedSurvey: data['hasCompletedSurvey'] ?? false,
      subscriptionEndDate: data['subscriptionEndDate']?.toDate(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
      communityPostCount: data['communityPostCount'] ?? 0,
      communityCommentCount: data['communityCommentCount'] ?? 0,
      communityLikeReceived: data['communityLikeReceived'] ?? 0,
      communityLikeGiven: data['communityLikeGiven'] ?? 0,
      communityRank: data['communityRank'] ?? 'newbie',
      totalConsultations: data['totalConsultations'] ?? 0,
      consecutiveDays: data['consecutiveDays'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      lastActiveDate: data['lastActiveDate']?.toDate(),
      experiencePoints: data['experiencePoints'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'emailVerified': emailVerified,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'freeConsultationsUsed': freeConsultationsUsed,
      'freeConsultationsLimit': freeConsultationsLimit,
      'lastConsultationDate': lastConsultationDate,
      'dailyConsultationsUsed': dailyConsultationsUsed,
      'dailyConsultationsLimit': dailyConsultationsLimit,
      'isSubscribed': isSubscribed,
      'hasCompletedSurvey': hasCompletedSurvey,
      'subscriptionEndDate': subscriptionEndDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'communityPostCount': communityPostCount,
      'communityCommentCount': communityCommentCount,
      'communityLikeReceived': communityLikeReceived,
      'communityLikeGiven': communityLikeGiven,
      'communityRank': communityRank,
      'totalConsultations': totalConsultations,
      'consecutiveDays': consecutiveDays,
      'currentStreak': currentStreak,
      'lastActiveDate': lastActiveDate,
      'experiencePoints': experiencePoints,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    bool? emailVerified,
    String? displayName,
    String? photoUrl,
    int? freeConsultationsUsed,
    int? freeConsultationsLimit,
    DateTime? lastConsultationDate,
    int? dailyConsultationsUsed,
    int? dailyConsultationsLimit,
    bool? isSubscribed,
    bool? hasCompletedSurvey,
    DateTime? subscriptionEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? communityPostCount,
    int? communityCommentCount,
    int? communityLikeReceived,
    int? communityLikeGiven,
    String? communityRank,
    int? totalConsultations,
    int? consecutiveDays,
    int? currentStreak,
    DateTime? lastActiveDate,
    int? experiencePoints,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      freeConsultationsUsed: freeConsultationsUsed ?? this.freeConsultationsUsed,
      freeConsultationsLimit: freeConsultationsLimit ?? this.freeConsultationsLimit,
      lastConsultationDate: lastConsultationDate ?? this.lastConsultationDate,
      dailyConsultationsUsed: dailyConsultationsUsed ?? this.dailyConsultationsUsed,
      dailyConsultationsLimit: dailyConsultationsLimit ?? this.dailyConsultationsLimit,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      hasCompletedSurvey: hasCompletedSurvey ?? this.hasCompletedSurvey,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      communityPostCount: communityPostCount ?? this.communityPostCount,
      communityCommentCount: communityCommentCount ?? this.communityCommentCount,
      communityLikeReceived: communityLikeReceived ?? this.communityLikeReceived,
      communityLikeGiven: communityLikeGiven ?? this.communityLikeGiven,
      communityRank: communityRank ?? this.communityRank,
      totalConsultations: totalConsultations ?? this.totalConsultations,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      experiencePoints: experiencePoints ?? this.experiencePoints,
    );
  }

  bool get canUseService {
    if (isSubscribed) return true;
    if (freeConsultationsUsed >= freeConsultationsLimit) return false;
    
    // 오늘 하루 상담 횟수 확인
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = lastConsultationDate;
    
    if (lastDate != null) {
      final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
      // 마지막 상담 날짜가 오늘이면 오늘의 사용 횟수 확인
      if (lastDateOnly.isAtSameMomentAs(today)) {
        return dailyConsultationsUsed < dailyConsultationsLimit;
      }
    }
    
    return true;
  }

  bool get needsSubscription {
    return !isSubscribed && freeConsultationsUsed >= freeConsultationsLimit;
  }

  bool get canUseTodayConsultation {
    if (isSubscribed) return true;
    if (freeConsultationsUsed >= freeConsultationsLimit) return false;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = lastConsultationDate;
    
    // 오늘 사용 횟수 확인
    if (lastDate != null) {
      final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
      if (lastDateOnly.isAtSameMomentAs(today)) {
        return dailyConsultationsUsed < dailyConsultationsLimit;
      }
    }
    
    return true;
  }

  String get consultationStatusMessage {
    if (isSubscribed) return '프리미엄 사용자 (무제한)';
    
    final remaining = freeConsultationsLimit - freeConsultationsUsed;
    
    if (remaining <= 0) {
      return '무료 상담을 모두 사용했습니다. 프리미엄 구독을 이용해보세요.';
    }
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = lastConsultationDate;
    
    int todayRemaining = dailyConsultationsLimit;
    if (lastDate != null) {
      final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
      if (lastDateOnly.isAtSameMomentAs(today)) {
        todayRemaining = dailyConsultationsLimit - dailyConsultationsUsed;
      }
    }
    
    if (todayRemaining <= 0) {
      return '오늘의 상담을 모두 사용했습니다. 내일 다시 이용해보세요. (전체 남은 횟수: $remaining회)';
    }
    
    return '무료 상담 $remaining회 남음 (오늘 $todayRemaining/${dailyConsultationsLimit}회 가능)';
  }

  // 레벨 시스템 관련 계산
  int get userLevel {
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

  String get userRank {
    final level = userLevel;
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

  int get expForNextLevel {
    final level = userLevel;
    if (level == 1) return 100;
    if (level == 2) return 300;
    if (level == 3) return 600;
    if (level == 4) return 1000;
    if (level == 5) return 1500;
    if (level == 6) return 2100;
    if (level == 7) return 2800;
    if (level == 8) return 3600;
    if (level == 9) return 4500;
    if (level == 10) return 5500;
    return (level + 1) * 1000;
  }

  int get expForCurrentLevel {
    final level = userLevel;
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

  double get levelProgress {
    final currentExp = experiencePoints;
    final currentLevelExp = expForCurrentLevel;
    final nextLevelExp = expForNextLevel;
    
    if (nextLevelExp == currentLevelExp) return 1.0;
    
    return (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp);
  }

  String get levelProgressText {
    final current = experiencePoints - expForCurrentLevel;
    final needed = expForNextLevel - expForCurrentLevel;
    return '$current / $needed';
  }

  // 등급별 색상
  Map<String, int> get rankColor {
    final level = userLevel;
    if (level == 1) return {'r': 156, 'g': 204, 'b': 101}; // 연한 초록 (새싹)
    if (level <= 3) return {'r': 255, 'g': 182, 'b': 193}; // 핑크 (설레임)
    if (level <= 5) return {'r': 255, 'g': 105, 'b': 180}; // 핫핑크 (첫키스)
    if (level <= 7) return {'r': 255, 'g': 69, 'b': 0}; // 오렌지레드 (달콤한사랑)
    if (level <= 10) return {'r': 220, 'g': 20, 'b': 60}; // 크림슨 (열정적사랑)
    if (level <= 15) return {'r': 128, 'g': 0, 'b': 128}; // 퍼플 (진실한사랑)
    if (level <= 25) return {'r': 75, 'g': 0, 'b': 130}; // 인디고 (운명적사랑)
    if (level <= 35) return {'r': 255, 'g': 215, 'b': 0}; // 골드 (영원한사랑)
    return {'r': 255, 'g': 20, 'b': 147}; // 딥핑크 (사랑의전설)
  }

  // 등급별 이모지
  String get rankEmoji {
    final level = userLevel;
    if (level == 1) return '🌱'; // 새싹
    if (level <= 3) return '💕'; // 설레임
    if (level <= 5) return '💋'; // 첫키스
    if (level <= 7) return '🍯'; // 달콤한사랑
    if (level <= 10) return '🔥'; // 열정적사랑
    if (level <= 15) return '💖'; // 진실한사랑
    if (level <= 25) return '✨'; // 운명적사랑
    if (level <= 35) return '👑'; // 영원한사랑
    return '🏆'; // 사랑의전설
  }

  // 등급별 설명
  String get rankDescription {
    final level = userLevel;
    if (level == 1) return '연애의 첫걸음을 내딛는 단계입니다';
    if (level <= 3) return '마음이 두근거리며 설레는 단계입니다';
    if (level <= 5) return '달콤한 로맨스를 경험하는 단계입니다';
    if (level <= 7) return '사랑의 달콤함을 만끽하는 단계입니다';
    if (level <= 10) return '열정적인 사랑에 빠진 단계입니다';
    if (level <= 15) return '진실하고 깊은 사랑을 아는 단계입니다';
    if (level <= 25) return '운명적인 만남을 믿는 단계입니다';
    if (level <= 35) return '영원한 사랑의 가치를 아는 단계입니다';
    return '사랑의 모든 것을 아는 전설적인 단계입니다';
  }
}