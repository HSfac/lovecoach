# 데이터베이스 선택 가이드 🗄️

## MCP로 직접 조절 가능한 데이터베이스

### ❌ **Firebase - MCP 직접 조절 불가능**
- Claude는 Firebase 콘솔에 직접 접근할 수 없음
- 수동으로 Firebase 프로젝트 설정 필요
- 보안 규칙은 직접 작성해야 함

### ✅ **MongoDB - 일부 조절 가능**
- MongoDB Atlas API를 통한 일부 작업 가능
- 데이터베이스 스키마 설계 도움
- 쿼리 최적화 조언 가능

## 데이터베이스 비교 분석

### 🔥 **Firebase (추천)** ⭐

#### 장점
- ✅ **Flutter 완벽 호환** - 공식 지원
- ✅ **실시간 동기화** - 채팅 앱에 최적
- ✅ **오프라인 지원** - 자동 캐싱
- ✅ **인증 통합** - Firebase Auth와 완벽 연동
- ✅ **서버리스** - 서버 관리 불필요
- ✅ **확장성** - Google 인프라
- ✅ **보안** - 내장 보안 규칙

#### 단점
- ❌ **쿼리 제한** - 복잡한 쿼리 어려움
- ❌ **벤더 락인** - Firebase에 종속
- ❌ **가격** - 트래픽 증가시 비싸질 수 있음

### 🍃 **MongoDB**

#### 장점
- ✅ **유연한 스키마** - JSON 기반
- ✅ **강력한 쿼리** - 복잡한 검색 가능
- ✅ **집계 파이프라인** - 고급 데이터 처리
- ✅ **클라우드/온프레미스** - 배포 선택권

#### 단점
- ❌ **서버 관리 필요** - Express.js 등 백엔드 필요
- ❌ **실시간 한계** - 별도 Socket.io 등 필요
- ❌ **복잡성** - 더 많은 설정 필요
- ❌ **Flutter 연동** - REST API 구현 필요

## 러브코치 앱에 최적한 선택

### 🏆 **Firebase 강력 추천 이유**

1. **채팅 앱 특성**
   - 실시간 메시지 동기화 필수
   - 오프라인 지원 중요
   - 사용자 인증 필요

2. **개발 효율성**
   ```dart
   // Firebase - 간단한 실시간 리스너
   FirebaseFirestore.instance
     .collection('chats')
     .where('userId', isEqualTo: userId)
     .snapshots()
   
   // vs MongoDB - REST API + WebSocket 필요
   ```

3. **비용 효율성**
   - 초기 사용자 수가 적을 때 Firebase가 유리
   - 읽기/쓰기 기반 과금으로 예측 가능

## 데이터 구조 설계

### Firebase 컬렉션 구조
```
users/
  {userId}/
    - email: string
    - displayName: string
    - isSubscribed: boolean
    - freeConsultationsUsed: number
    - createdAt: timestamp

chats/
  {chatId}/
    - userId: string
    - category: string (flirting/dating/breakup/reconciliation)
    - content: string
    - type: string (user/ai)
    - timestamp: timestamp

subscriptions/
  {userId}/
    - status: string (active/expired/canceled)
    - startDate: timestamp
    - endDate: timestamp
    - receiptData: string
```

## 마이그레이션 전략

만약 나중에 MongoDB로 이전이 필요하다면:

1. **점진적 마이그레이션**
   - 새로운 기능부터 MongoDB 사용
   - 기존 데이터는 Firebase 유지

2. **하이브리드 구조**
   - 사용자 인증: Firebase Auth
   - 채팅 데이터: Firebase Firestore
   - 분석 데이터: MongoDB

## 결론

**러브코치 앱의 경우 Firebase가 최선의 선택**

### 이유:
1. **빠른 개발**: 백엔드 서버 구축 불필요
2. **실시간 기능**: 채팅에 최적화
3. **확장성**: Google 인프라 활용
4. **유지보수**: 서버 관리 부담 없음
5. **보안**: 내장 보안 기능

### MCP 관점에서:
- Firebase는 웹 콘솔에서 설정
- MongoDB는 API 기반으로 일부 자동화 가능
- 하지만 Firebase의 장점이 압도적

Firebase를 계속 사용하되, 필요시 나중에 MongoDB를 보조적으로 활용하는 것을 권장합니다.