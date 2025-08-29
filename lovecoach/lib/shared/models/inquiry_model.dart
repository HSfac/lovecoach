class InquiryModel {
  final String id;
  final String userId;
  final String userEmail;
  final String message;
  final String status; // 'pending', 'processing', 'resolved'
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? adminReply;

  const InquiryModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.message,
    this.status = 'pending',
    required this.createdAt,
    this.resolvedAt,
    this.adminReply,
  });

  factory InquiryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return InquiryModel(
      id: id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      resolvedAt: data['resolvedAt']?.toDate(),
      adminReply: data['adminReply'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'message': message,
      'status': status,
      'createdAt': createdAt,
      'resolvedAt': resolvedAt,
      'adminReply': adminReply,
    };
  }

  InquiryModel copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? resolvedAt,
    String? adminReply,
  }) {
    return InquiryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      adminReply: adminReply ?? this.adminReply,
    );
  }

  String get statusDisplayText {
    switch (status) {
      case 'pending':
        return '접수 대기';
      case 'processing':
        return '처리 중';
      case 'resolved':
        return '완료';
      default:
        return '알 수 없음';
    }
  }
}