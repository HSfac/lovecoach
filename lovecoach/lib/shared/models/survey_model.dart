class SurveyModel {
  final String? gender;
  final int? ageRange;
  final String? relationshipStatus;
  final List<String> interests;
  final String? communicationStyle;
  final DateTime completedAt;

  const SurveyModel({
    this.gender,
    this.ageRange,
    this.relationshipStatus,
    this.interests = const [],
    this.communicationStyle,
    required this.completedAt,
  });

  factory SurveyModel.fromFirestore(Map<String, dynamic> data) {
    return SurveyModel(
      gender: data['gender'],
      ageRange: data['ageRange'],
      relationshipStatus: data['relationshipStatus'],
      interests: List<String>.from(data['interests'] ?? []),
      communicationStyle: data['communicationStyle'],
      completedAt: data['completedAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'gender': gender,
      'ageRange': ageRange,
      'relationshipStatus': relationshipStatus,
      'interests': interests,
      'communicationStyle': communicationStyle,
      'completedAt': completedAt,
    };
  }

  SurveyModel copyWith({
    String? gender,
    int? ageRange,
    String? relationshipStatus,
    List<String>? interests,
    String? communicationStyle,
    DateTime? completedAt,
  }) {
    return SurveyModel(
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      interests: interests ?? this.interests,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // Helper methods
  String get genderDisplayText => gender ?? '미입력';
  
  String get ageDisplayText {
    if (ageRange == null) return '미입력';
    const ageRanges = ['20대 초반', '20대 후반', '30대 초반', '30대 후반', '40대 이상'];
    return ageRange! < ageRanges.length ? ageRanges[ageRange!] : '미입력';
  }
  
  String get relationshipStatusDisplayText => relationshipStatus ?? '미입력';
  String get communicationStyleDisplayText => communicationStyle ?? '미입력';
  
  String get interestsDisplayText {
    if (interests.isEmpty) return '미입력';
    return interests.join(', ');
  }

  bool get isComplete {
    return gender != null && 
           ageRange != null && 
           relationshipStatus != null && 
           interests.isNotEmpty && 
           communicationStyle != null;
  }
}