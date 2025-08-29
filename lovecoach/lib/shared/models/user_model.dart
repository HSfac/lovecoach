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
}