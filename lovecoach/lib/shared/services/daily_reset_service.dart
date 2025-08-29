import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DailyResetService {
  static final DailyResetService _instance = DailyResetService._internal();
  factory DailyResetService() => _instance;
  DailyResetService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _dailyTimer;

  void startDailyResetTimer() {
    _scheduleDailyReset();
  }

  void _scheduleDailyReset() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    if (kDebugMode) {
      print('DailyResetService: 다음 리셋까지 ${timeUntilMidnight.inHours}시간 ${timeUntilMidnight.inMinutes % 60}분');
    }

    _dailyTimer?.cancel();
    _dailyTimer = Timer(timeUntilMidnight, () {
      _resetDailyConsultations();
      _scheduleDailyReset(); // 다음 날 리셋 예약
    });
  }

  Future<void> _resetDailyConsultations() async {
    try {
      if (kDebugMode) {
        print('DailyResetService: 일일 상담 횟수 리셋 시작');
      }

      final querySnapshot = await _firestore
          .collection('users')
          .where('hasUsedTodaysConsultation', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final batch = _firestore.batch();
        
        for (final doc in querySnapshot.docs) {
          batch.update(doc.reference, {
            'hasUsedTodaysConsultation': false,
          });
        }

        await batch.commit();
        
        if (kDebugMode) {
          print('DailyResetService: ${querySnapshot.docs.length}명의 사용자 일일 상담 리셋 완료');
        }
      } else {
        if (kDebugMode) {
          print('DailyResetService: 리셋할 사용자가 없음');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('DailyResetService 에러: $e');
      }
    }
  }

  void dispose() {
    _dailyTimer?.cancel();
  }

  // 수동으로 사용자별 일일 상담 상태 체크 및 리셋
  Future<bool> checkAndResetUserDailyConsultation(String userId, DateTime? lastConsultationDate) async {
    if (lastConsultationDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDateOnly = DateTime(
      lastConsultationDate.year,
      lastConsultationDate.month,
      lastConsultationDate.day,
    );

    // 마지막 상담이 어제 이전이면 리셋
    if (lastDateOnly.isBefore(today)) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'hasUsedTodaysConsultation': false,
        });
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('사용자 일일 상담 리셋 에러: $e');
        }
        return false;
      }
    }

    return false;
  }
}