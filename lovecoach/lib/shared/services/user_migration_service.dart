import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserMigrationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 기존 사용자들의 무료 상담 제한을 5회로 업데이트하고 새로운 필드들을 추가
  static Future<void> migrateUserLimits() async {
    try {
      if (kDebugMode) {
        print('사용자 데이터 마이그레이션 시작...');
      }

      // 모든 사용자 조회
      final querySnapshot = await _firestore.collection('users').get();
      
      if (querySnapshot.docs.isEmpty) {
        if (kDebugMode) {
          print('마이그레이션할 사용자가 없습니다.');
        }
        return;
      }

      final batch = _firestore.batch();
      int migrationCount = 0;

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        bool needsUpdate = false;
        final updates = <String, dynamic>{};

        // freeConsultationsLimit이 5가 아닌 경우 업데이트
        if (data['freeConsultationsLimit'] != 5) {
          updates['freeConsultationsLimit'] = 5;
          needsUpdate = true;
        }

        // dailyConsultationsUsed 필드가 없는 경우 추가
        if (!data.containsKey('dailyConsultationsUsed')) {
          updates['dailyConsultationsUsed'] = 0;
          needsUpdate = true;
        }

        // dailyConsultationsLimit 필드가 없는 경우 추가
        if (!data.containsKey('dailyConsultationsLimit')) {
          updates['dailyConsultationsLimit'] = 5;
          needsUpdate = true;
        }

        // hasUsedTodaysConsultation 필드가 있는 경우 제거하고 dailyConsultationsUsed로 변환
        if (data.containsKey('hasUsedTodaysConsultation')) {
          final hasUsedToday = data['hasUsedTodaysConsultation'] as bool? ?? false;
          if (hasUsedToday && !data.containsKey('dailyConsultationsUsed')) {
            updates['dailyConsultationsUsed'] = 1;
          }
          updates['hasUsedTodaysConsultation'] = FieldValue.delete();
          needsUpdate = true;
        }

        if (needsUpdate) {
          updates['updatedAt'] = DateTime.now();
          batch.update(doc.reference, updates);
          migrationCount++;
        }
      }

      if (migrationCount > 0) {
        await batch.commit();
        if (kDebugMode) {
          print('$migrationCount명의 사용자 데이터 마이그레이션 완료');
        }
      } else {
        if (kDebugMode) {
          print('마이그레이션이 필요한 사용자가 없습니다.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('사용자 데이터 마이그레이션 실패: $e');
      }
      rethrow;
    }
  }

  /// 특정 사용자의 데이터만 마이그레이션
  static Future<void> migrateSpecificUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) return;

      final data = doc.data()!;
      final updates = <String, dynamic>{};
      bool needsUpdate = false;

      // freeConsultationsLimit이 5가 아닌 경우 업데이트
      if (data['freeConsultationsLimit'] != 5) {
        updates['freeConsultationsLimit'] = 5;
        needsUpdate = true;
      }

      // 새로운 필드들 추가
      if (!data.containsKey('dailyConsultationsUsed')) {
        updates['dailyConsultationsUsed'] = 0;
        needsUpdate = true;
      }

      if (!data.containsKey('dailyConsultationsLimit')) {
        updates['dailyConsultationsLimit'] = 5;
        needsUpdate = true;
      }

      if (needsUpdate) {
        updates['updatedAt'] = DateTime.now();
        await _firestore.collection('users').doc(userId).update(updates);
        
        if (kDebugMode) {
          print('사용자 $userId 데이터 마이그레이션 완료');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('사용자 $userId 마이그레이션 실패: $e');
      }
    }
  }
}