# 🧠 Claude API 연동 가이드

## ✨ 새로 추가된 기능

### **OpenAI + Claude 듀얼 AI 시스템**
- 🤖 **OpenAI GPT-3.5**: 빠르고 일관된 응답
- 🧠 **Claude 3.5 Sonnet**: 깊이 있는 심리 분석

## 1단계: Claude API 키 발급

### 1.1 Anthropic Console 접속
1. https://console.anthropic.com 접속
2. Google/이메일 계정으로 가입/로그인
3. **"Get API Keys"** 클릭

### 1.2 API 키 생성
```
1. "Create Key" 버튼 클릭
2. 키 이름: "LoveCoach App"
3. API 키 복사 (sk-ant-로 시작)
```

### 1.3 결제 정보 등록
```
1. "Billing" 메뉴로 이동
2. 결제 수단 등록
3. 사용량 제한 설정 (권장: $20/월)
```

## 2단계: 환경변수 설정

### .env 파일 업데이트
```env
# AI API Keys
OPENAI_API_KEY=sk-your-actual-openai-key
CLAUDE_API_KEY=sk-ant-your-actual-claude-key

# AI 설정
DEFAULT_AI_MODEL=claude  # openai 또는 claude

# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
# ... 기존 Firebase 설정
```

## 3단계: 앱에서 AI 모델 선택

### 3.1 AI 설정 화면 접근
```
메인 화면 → 🧠 아이콘 클릭
또는
프로필 → AI 설정 메뉴
```

### 3.2 AI 모델 선택
1. **OpenAI GPT-3.5** 또는 **Claude 3.5** 선택
2. **연결 테스트** 버튼으로 동작 확인
3. 설정 자동 저장

## 🆚 AI 모델 비교

### 🤖 **OpenAI GPT-3.5-turbo**
#### 장점:
- ✅ **빠른 응답** (1-3초)
- ✅ **저렴한 비용** (토큰당 $0.001)
- ✅ **일관된 성능**
- ✅ **다양한 주제 커버**

#### 단점:
- ❌ 때로는 표면적인 답변
- ❌ 창의성 제한

#### 💰 **비용**: 1회 상담 약 ₩0.7

---

### 🧠 **Claude 3.5 Sonnet**  
#### 장점:
- ✅ **깊이 있는 분석** 
- ✅ **뉘앙스 있는 이해**
- ✅ **복잡한 상황 처리 탁월**
- ✅ **더 인간적인 대화**
- ✅ **심리적 통찰력**

#### 단점:
- ❌ 상대적으로 느린 응답 (3-5초)
- ❌ 높은 비용 (토큰당 $0.015)

#### 💰 **비용**: 1회 상담 약 ₩10

## 🎯 상황별 추천

### 👥 **일반적인 연애 상담** → OpenAI
- 빠른 조언이 필요한 경우
- 간단한 썸/연애 문제
- 비용 효율성 중시

### 💔 **복잡한 심리 상담** → Claude  
- 이별 후 깊은 상처 치유
- 복잡한 관계 문제 분석
- 재회 상담의 섬세한 판단
- 심층적인 자기 분석

## 📊 실제 사용 시나리오

### 시나리오 1: 썸 상담
```
사용자: "3개월째 썸타는데 고백해도 될까요?"

OpenAI 답변: 
"3개월은 충분한 시간이에요. 상대방의 반응을 
보면서 자연스럽게 고백해보세요..."

Claude 답변:
"3개월간의 관계를 분석해보면, 상대방의 미묘한 
신호들과 당신의 감정 상태를 종합적으로 고려할 
필요가 있어요. 먼저 상대방이 보인 긍정적 신호들을..."
```

### 시나리오 2: 이별 후 상담
```
OpenAI: 기본적인 위로와 조언
Claude: 깊이 있는 심리 분석과 치유 과정 가이드
```

## 🔧 기술적 구현

### 동적 AI 모델 선택
```dart
// 사용자가 선택한 AI 모델에 따라 자동 분기
final selectedModel = ref.read(selectedAIModelProvider);

switch (selectedModel) {
  case AIModel.claude:
    // Claude API 호출
  case AIModel.openai:
    // OpenAI API 호출
}
```

### 사용자 설정 저장
```dart
// SharedPreferences로 선택 유지
await prefs.setString('selected_ai_model', 'claude');
```

## 💡 활용 팁

### 1. **하이브리드 사용**
- 빠른 답변: OpenAI
- 심층 상담: Claude

### 2. **상황별 전환**
- 썸/연애: OpenAI로 빠른 조언
- 이별/재회: Claude로 깊은 분석

### 3. **비용 최적화**
- 무료 사용자: OpenAI만 제공
- 프리미엄: Claude 접근 권한 추가

## ✅ 완성된 기능들

- ✅ **듀얼 AI 시스템** - OpenAI & Claude 동시 지원
- ✅ **실시간 모델 선택** - 사용자가 언제든 변경 가능
- ✅ **연결 상태 확인** - API 키 유효성 실시간 체크
- ✅ **비교 가이드** - 모델별 장단점 명시
- ✅ **설정 저장** - 사용자 선택 기억
- ✅ **통합 UI** - 일관된 디자인

## 🚀 이제 완전히 준비 완료!

**OpenAI와 Claude 모두 사용 가능한 최고급 러브코치 앱**이 완성되었습니다!

### 사용자 경험:
1. **AI 선택의 자유** - 상황에 맞는 AI 선택
2. **투명한 비교** - 모델별 특성 명확히 제시  
3. **seamless 전환** - 언제든 AI 변경 가능
4. **안정적 연결** - 실시간 상태 모니터링

Claude API 키만 추가하면 **업계 최고 수준의 AI 상담 서비스**를 제공할 수 있습니다! 🎉