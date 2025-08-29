# 🚀 러브코치 앱 설정 가이드

## 1. 환경변수 설정 ⚙️

### .env 파일 수정
```bash
# .env 파일 편집
nano .env
```

필수 값들을 입력하세요:
```env
# OpenAI API Key (https://platform.openai.com/api-keys)
OPENAI_API_KEY=sk-your-actual-openai-key

# Firebase 설정 (Firebase Console에서 확인)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_APP_ID=your-app-id
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
```

## 2. Firebase 프로젝트 설정 🔥

### Firebase Console 작업
1. https://console.firebase.google.com 접속
2. 새 프로젝트 생성: "lovecoach-app"
3. Authentication 활성화 (이메일/비밀번호, Google)
4. Firestore Database 생성 (테스트 모드로 시작)
5. Flutter 앱 등록 (Android/iOS)

### Firebase CLI 설정
```bash
# Firebase CLI 설치
npm install -g firebase-tools

# 로그인
firebase login

# 프로젝트 초기화
firebase init

# FlutterFire CLI 설치 및 설정
dart pub global activate flutterfire_cli
flutterfire configure
```

## 3. OpenAI API 설정 🤖

### OpenAI 계정 설정
1. https://platform.openai.com 가입
2. API Keys 섹션에서 새 키 생성
3. 결제 정보 등록 (사용량에 따른 과금)
4. 사용량 제한 설정 (예: 월 $50)

### API 비용 예상 (GPT-3.5-turbo)
- 1회 상담 (평균 500토큰): 약 ₩0.7
- 월 1000회 상담: 약 ₩700
- 충분히 저렴한 비용

## 4. 앱 실행 명령어 📱

### 개발 환경에서 실행
```bash
# 패키지 설치
flutter pub get

# iOS 실행 (Mac only)
flutter run -d ios

# Android 실행
flutter run -d android

# 웹에서 실행 (테스트용)
flutter run -d web
```

### 빌드 명령어
```bash
# Android APK 빌드
flutter build apk --release

# iOS 앱 빌드 (Mac only)
flutter build ios --release

# 웹 빌드
flutter build web
```

## 5. 결제 시스템 설정 💳

### App Store Connect / Google Play Console
1. **iOS**: App Store Connect에서 인앱구매 상품 등록
   - 상품 ID: `premium_monthly_9900`
   - 타입: 자동 갱신 구독
   - 가격: ₩9,900

2. **Android**: Google Play Console에서 구독 상품 등록
   - 동일한 상품 ID 사용
   - 기본 요금제: ₩9,900/월

### 테스트 설정
```bash
# iOS 테스트 (Sandbox 계정 필요)
# Android 테스트 (테스트 트랙 업로드 필요)
```

## 6. Firebase 보안 규칙 🔒

### Firestore 규칙 설정
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자는 자신의 데이터만 접근
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 채팅은 자신의 것만 접근
    match /chats/{chatId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## 7. 배포 전 체크리스트 ✅

### 필수 확인사항
- [ ] Firebase 프로젝트 설정 완료
- [ ] OpenAI API 키 등록 및 결제 정보 입력
- [ ] 인앱 결제 상품 등록 (iOS/Android)
- [ ] Firebase 보안 규칙 설정
- [ ] 앱 아이콘 및 스플래시 스크린 설정
- [ ] 개인정보처리방침 및 이용약관 작성

### 성능 최적화
```bash
# 코드 분석
flutter analyze

# 빌드 사이즈 확인
flutter build apk --analyze-size

# 성능 프로파일링
flutter run --profile
```

## 8. 실제 사용자 배포 🌟

### 스토어 등록
1. **구글 플레이스토어**
   - 개발자 계정 ($25 일회성)
   - APK 업로드 및 심사

2. **애플 앱스토어**
   - 개발자 계정 ($99/년)
   - 앱 심사 (평균 24-48시간)

### 마케팅 전략
- SNS 홍보 (인스타그램, 틱톡)
- 연애 관련 커뮤니티 홍보
- 무료 체험 강조
- 리뷰 이벤트

## 🎯 완성된 기능들

✅ **사용자 인증**: 이메일 로그인/회원가입
✅ **AI 상담 시스템**: OpenAI GPT-3.5 연동
✅ **4가지 상담 카테고리**: 썸/연애중/이별후/재회
✅ **구독 시스템**: 인앱 결제 연동
✅ **실시간 채팅 UI**: Firebase 실시간 동기화
✅ **무료 횟수 관리**: 3회 무료 체험
✅ **프로필 관리**: 사용자 정보 관리

이제 Firebase 프로젝트만 설정하면 바로 사용 가능한 완전한 러브코치 앱입니다! 🎉