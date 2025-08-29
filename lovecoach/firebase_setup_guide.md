# 🔥 Firebase 설정 완전 가이드

## 1단계: Firebase 계정 및 프로젝트 생성

### 1.1 Firebase Console 접속
1. https://console.firebase.google.com 접속
2. Google 계정으로 로그인
3. **"프로젝트 추가"** 클릭

### 1.2 프로젝트 생성
```
프로젝트 이름: lovecoach-app (또는 원하는 이름)
프로젝트 ID: lovecoach-app-12345 (자동 생성됨)
```

1. **프로젝트 이름** 입력 → 계속
2. **Google 애널리틱스** 사용 체크 → 계속  
3. **애널리틱스 계정** 선택 → 프로젝트 만들기
4. 완료되면 **계속** 클릭

## 2단계: Firebase 서비스 설정

### 2.1 Authentication 설정
1. 왼쪽 메뉴에서 **"Authentication"** 클릭
2. **"시작하기"** 클릭
3. **"Sign-in method"** 탭 클릭
4. 다음 제공업체를 활성화:

#### 이메일/비밀번호 활성화
```
1. "이메일/비밀번호" 클릭
2. "사용 설정" 토글 ON
3. "저장" 클릭
```

#### Google 로그인 활성화 (선택사항)
```
1. "Google" 클릭
2. "사용 설정" 토글 ON
3. "프로젝트 지원 이메일" 선택
4. "저장" 클릭
```

### 2.2 Firestore Database 설정
1. 왼쪽 메뉴에서 **"Firestore Database"** 클릭
2. **"데이터베이스 만들기"** 클릭
3. **보안 규칙** 선택:
   - **"테스트 모드에서 시작"** 선택 (개발용)
   - **"다음"** 클릭
4. **Cloud Firestore 위치** 선택:
   - **"asia-northeast3 (서울)"** 선택 (한국 서비스용)
   - **"완료"** 클릭

### 2.3 Cloud Messaging 설정 (푸시 알림)
1. 왼쪽 메뉴에서 **"Messaging"** 클릭
2. **"시작하기"** 클릭
3. **첫 번째 캠페인 만들기** (선택사항)
4. **서버 키** 복사 (나중에 서버에서 사용)

### 2.4 Storage 설정 (선택사항)
1. 왼쪽 메뉴에서 **"Storage"** 클릭
2. **"시작하기"** 클릭
3. **"테스트 모드에서 시작"** → **"다음"**
4. **위치**: "asia-northeast3 (서울)" → **"완료"**

## 3단계: Flutter 앱 등록

### 3.1 Android 앱 추가
1. 프로젝트 개요에서 **Android 아이콘** 클릭
2. 앱 등록 정보 입력:
```
Android 패키지 이름: com.example.lovecoach
앱 닉네임: LoveCoach Android
디버그 서명 인증서 SHA-1: (나중에 추가 가능)
```
3. **"앱 등록"** 클릭

### 3.2 google-services.json 다운로드
1. **google-services.json** 파일 다운로드
2. 파일을 `android/app/` 폴더에 복사

### 3.3 iOS 앱 추가 (Mac 사용자만)
1. 프로젝트 개요에서 **iOS 아이콘** 클릭
2. 앱 등록 정보 입력:
```
iOS 번들 ID: com.example.lovecoach
앱 닉네임: LoveCoach iOS
앱 스토어 ID: (나중에 추가)
```
3. **"앱 등록"** 클릭
4. **GoogleService-Info.plist** 다운로드
5. 파일을 `ios/Runner/` 폴더에 추가

## 4단계: Firebase 설정 정보 확인

### 4.1 프로젝트 설정 확인
1. **프로젝트 설정** (⚙️) 클릭
2. **"일반"** 탭에서 다음 정보 확인:

```
프로젝트 ID: your-project-id
웹 API 키: your-web-api-key
프로젝트 번호: your-project-number
```

### 4.2 웹 앱 추가 (웹 버전용 - 선택사항)
1. **"웹 앱 추가"** 아이콘 클릭
2. 앱 닉네임: "LoveCoach Web"
3. Firebase 호스팅 체크 (선택)
4. **"앱 등록"** 클릭
5. Firebase 구성 정보 복사

## 5단계: .env 파일 설정

### 5.1 환경변수 입력
`lovecoach/.env` 파일을 열고 다음 정보를 입력:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-web-api-key
FIREBASE_APP_ID=your-web-app-id
FIREBASE_MESSAGING_SENDER_ID=your-project-number
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com

# OpenAI API Key
OPENAI_API_KEY=sk-your-openai-key-here

# Environment
ENV=development
```

### 5.2 실제 값 입력 예시
```env
# 실제 예시 (가상의 값)
FIREBASE_PROJECT_ID=lovecoach-app-12345
FIREBASE_API_KEY=AIzaSyBk1q2w3e4r5t6y7u8i9o0p1a2s3d4f5g6
FIREBASE_APP_ID=1:123456789012:web:abcdef123456789
FIREBASE_MESSAGING_SENDER_ID=123456789012
FIREBASE_AUTH_DOMAIN=lovecoach-app-12345.firebaseapp.com
FIREBASE_STORAGE_BUCKET=lovecoach-app-12345.appspot.com
```

## 6단계: Firebase 보안 규칙 설정

### 6.1 Firestore 보안 규칙
1. **Firestore Database** → **"규칙"** 탭
2. 다음 규칙 붙여넣기:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // 사용자 문서: 본인만 읽기/쓰기 가능
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // 채팅 문서: 본인 채팅만 읽기/쓰기 가능
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // 구독 정보: 본인만 접근 가능
    match /subscriptions/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. **"게시"** 클릭

### 6.2 Storage 보안 규칙 (Storage 사용시)
1. **Storage** → **"규칙"** 탭
2. 다음 규칙 붙여넣기:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 7단계: 앱 실행 및 테스트

### 7.1 Flutter 앱 실행
```bash
# 패키지 설치
flutter pub get

# 앱 실행
flutter run
```

### 7.2 Firebase 연결 테스트
1. 앱에서 회원가입 진행
2. Firebase Console → **Authentication** → **Users**에서 사용자 확인
3. 앱에서 메시지 전송
4. Firebase Console → **Firestore Database**에서 데이터 확인

## 🚨 주의사항

### 보안
- **절대** API 키를 GitHub에 커밋하지 말 것
- `.env` 파일을 `.gitignore`에 추가
- 운영 환경에서는 보안 규칙을 더 엄격하게 설정

### 비용
- Firebase 무료 할당량 확인
- Firestore: 읽기 50,000회/일, 쓰기 20,000회/일
- 사용량 모니터링 설정 권장

### 백업
- Firestore 데이터 정기 백업 설정
- 보안 규칙 버전 관리

## ✅ 완료 체크리스트

- [ ] Firebase 프로젝트 생성
- [ ] Authentication 활성화 (이메일/비밀번호)
- [ ] Firestore Database 생성
- [ ] Android 앱 등록 및 google-services.json 추가
- [ ] iOS 앱 등록 및 GoogleService-Info.plist 추가 (iOS 사용시)
- [ ] .env 파일 설정
- [ ] 보안 규칙 설정
- [ ] 앱 실행 및 연결 테스트

이제 Firebase 설정이 완료되었습니다! 앱을 실행하면 완전히 작동하는 러브코치 앱을 사용할 수 있습니다. 🎉