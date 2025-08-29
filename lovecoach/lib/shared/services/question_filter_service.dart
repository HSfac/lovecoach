class QuestionFilterService {
  // 연애 관련 키워드들
  static const List<String> _loveRelatedKeywords = [
    // 직접적인 연애 키워드
    '연애', '사랑', '좋아해', '썸', '남친', '여친', '연인', '애인', '커플', '데이트',
    '고백', '프러포즈', '결혼', '결혼식', '신혼', '부부', '배우자', '남편', '아내',
    
    // 감정 관련
    '호감', '끌림', '마음', '감정', '설렘', '두근', '보고싶', '그리워', '외로운',
    '질투', '서운', '미안', '화났', '상처', '아픈', '슬픈', '행복', '기쁜',
    
    // 관계 관련
    '만남', '소개팅', '미팅', '헤어짐', '이별', '재회', '복합', '화해', '싸움',
    '갈등', '오해', '불화', '다툼', '소통', '대화', '약속', '기념일',
    
    // 상황별 키워드
    '첫사랑', '짝사랑', '양다리', '바람', '불륜', '외도', '이혼', '재혼',
    '원거리', '장거리', '국제연애', '나이차', '동갑', '연상', '연하',
    
    // 행동 관련
    '만나다', '보다', '잡다', '안다', '키스', '뽀뽀', '껴안', '스킨십',
    '선물', '편지', '메시지', '카톡', '전화', '영상통화',
    
    // 장소/상황
    '집', '카페', '영화관', '식당', '공원', '바다', '여행', '드라이브'
  ];

  // 비연애 관련 키워드들 (이런 것들이 포함되면 필터링)
  static const List<String> _nonLoveKeywords = [
    '코딩', '프로그래밍', '개발', '컴퓨터', '수학', '과학', '물리', '화학',
    '정치', '경제', '주식', '투자', '부동산', '금융', '비트코인',
    '요리', '레시피', '운동', '헬스', '축구', '야구', '게임', '만화',
    '날씨', '뉴스', '교통', '병원', '의료', '법률', '세금'
  ];

  /// 메시지가 연애 상담 관련인지 확인
  static bool isLoveRelatedQuestion(String message) {
    final lowerMessage = message.toLowerCase().replaceAll(' ', '');
    
    // 1. 연애 관련 키워드 포함 여부 확인
    final hasLoveKeywords = _loveRelatedKeywords.any((keyword) => 
        lowerMessage.contains(keyword.toLowerCase()));
    
    // 2. 비연애 키워드 포함 여부 확인
    final hasNonLoveKeywords = _nonLoveKeywords.any((keyword) => 
        lowerMessage.contains(keyword.toLowerCase()));
    
    // 3. 짧은 메시지는 통과 (인사, 간단한 대답 등)
    if (message.trim().length < 10) {
      return true;
    }
    
    // 4. 연애 키워드가 있고 비연애 키워드가 없으면 통과
    if (hasLoveKeywords && !hasNonLoveKeywords) {
      return true;
    }
    
    // 5. 연애 키워드가 없지만 의문문 형태이고 감정 표현이 있으면 통과
    if (_containsEmotionalExpression(message) && _isQuestion(message)) {
      return true;
    }
    
    // 6. 카테고리별 맥락 고려
    return _hasContextualClues(message);
  }

  /// 감정 표현이 포함되어 있는지 확인
  static bool _containsEmotionalExpression(String message) {
    final emotionalWords = [
      '기분', '느낌', '생각', '마음', '감정', '기쁘', '슬프', '화나', '답답',
      '속상', '서운', '미안', '고마', '사랑', '좋아', '싫어', '힘들', '어려'
    ];
    
    return emotionalWords.any((word) => message.contains(word));
  }

  /// 질문 형태인지 확인
  static bool _isQuestion(String message) {
    final questionMarkers = ['?', '요?', '까?', '나?', '지?', '을까', '는지', '어떻게'];
    return questionMarkers.any((marker) => message.contains(marker));
  }

  /// 맥락적 단서가 있는지 확인
  static bool _hasContextualClues(String message) {
    final contextualClues = [
      '상대방', '그사람', '상대', '걔', '그녀', '그남자', '그여자',
      '친구', '동료', '선배', '후배', '동창', '이성', '남성', '여성'
    ];
    
    return contextualClues.any((clue) => message.contains(clue));
  }

  /// 필터링 메시지 생성
  static String getFilterMessage() {
    final messages = [
      '''😊 안녕하세요! 저는 연애 전문 상담사예요.

현재 연애, 썸, 이별, 재회와 관련된 고민만 상담받고 있어요.

💕 이런 주제들로 이야기해주세요:
• 썸 타는 상대와의 관계
• 연인과의 갈등이나 소통 문제  
• 이별 후 마음 정리
• 재회 가능성과 방법

다른 주제의 질문은 전문 분야가 아니라서 정확한 답변을 드리기 어려워요. 연애 관련 고민이 있으시다면 언제든 말씀해 주세요! 🤗''',

      '''💖 러브코치입니다!

지금 질문해주신 내용이 제 전문 분야인 연애 상담과는 조금 다른 것 같아요.

저는 이런 연애 고민들을 전문으로 상담해드려요:
• 좋아하는 사람과 가까워지는 방법
• 연인과의 관계 개선 방안
• 이별 상처 회복과 성장
• 헤어진 연인과의 재회

연애나 인간관계에 관한 고민이 있으시면 편하게 말씀해 주세요! 더 도움이 되는 상담을 해드릴게요 😊''',

      '''🌸 안녕하세요! 연애 상담 전문가예요.

혹시 연애나 사랑에 관한 고민이 있으신가요?

제가 도와드릴 수 있는 분야는:
• 💕 썸과 연애 시작
• ❤️ 연인관계 유지와 발전
• 💙 이별 후 마음 치유
• 💚 재회와 관계 회복

다른 주제보다는 이런 연애 이야기로 상담받으시면 훨씬 전문적이고 구체적인 조언을 드릴 수 있어요! 어떤 연애 고민이든 편하게 털어놓으세요 🤗'''
    ];

    // 랜덤하게 하나 선택
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 카테고리별 안내 메시지
  static String getCategoryGuideMessage(String categoryName) {
    switch (categoryName) {
      case 'flirting':
        return '''💕 썸 상담실에 오신 걸 환영해요!

이런 고민들을 함께 해결해봐요:
• 상대방이 나를 어떻게 생각하는지 궁금해요
• 어떻게 자연스럽게 다가갈까요?
• 썸에서 연애로 발전시키고 싶어요
• 상대방의 신호를 어떻게 해석해야 할까요?''';

      case 'dating':
        return '''❤️ 연애 상담실에 오신 걸 환영해요!

이런 고민들을 나눠보세요:
• 연인과 소통이 잘 안 돼요
• 자주 다투게 되는데 어떻게 해야 할까요?
• 관계를 더 발전시키고 싶어요
• 연인의 마음을 더 잘 이해하고 싶어요''';

      case 'breakup':
        return '''💙 치유 상담실에 오신 걸 환영해요!

힘든 시간을 함께 이겨내봐요:
• 이별 후 마음이 너무 아파요
• 상대방을 잊고 싶어요
• 자존감을 회복하고 싶어요
• 새로운 시작을 준비하고 싶어요''';

      case 'reconciliation':
        return '''💚 재회 상담실에 오신 걸 환영해요!

복잡한 마음을 정리해봐요:
• 다시 연락을 시도해볼까요?
• 재회 가능성이 있을까요?
• 같은 문제가 반복되지 않을까요?
• 어떻게 접근하는 게 좋을까요?''';

      default:
        return getFilterMessage();
    }
  }
}