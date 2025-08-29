import 'package:dio/dio.dart';
import '../models/chat_message.dart';
import '../models/ai_model.dart';
import '../../core/config/env_config.dart';

class ClaudeService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.anthropic.com/v1';

  ClaudeService() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'x-api-key': EnvConfig.claudeApiKey,
        'Content-Type': 'application/json',
        'anthropic-version': '2023-06-01',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  Future<String> generateResponse({
    required String userMessage,
    required ConsultationCategory category,
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      final systemPrompt = _getSystemPrompt(category);
      final messages = _buildMessages(userMessage, conversationHistory);

      final response = await _dio.post(
        '/messages',
        data: {
          'model': AIModel.claude.modelId,
          'max_tokens': 1000,
          'system': systemPrompt,
          'messages': messages,
          'temperature': 0.7,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['content'][0]['text'] as String;
        return content.trim();
      } else {
        throw Exception('Claude API 호출 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Claude API 키가 유효하지 않습니다.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('Claude API 사용량 한도를 초과했습니다. 잠시 후 다시 시도해주세요.');
      } else {
        throw Exception('네트워크 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('Claude AI 응답 생성 중 오류가 발생했습니다: $e');
    }
  }

  String _getSystemPrompt(ConsultationCategory category) {
    const basePrompt = '''
당신은 전문 연애 상담사 "러브코치"입니다. 
사용자의 연애 고민을 듣고 따뜻하고 공감적인 조언을 제공합니다.
답변은 한국어로 하고, 친근하면서도 전문적인 톤을 유지하세요.
구체적이고 실용적인 조언을 제공하되, 상황을 단정하지 말고 다양한 관점을 제시하세요.
답변은 2-3문단 정도로 적절한 길이를 유지하세요.

Claude AI의 강점을 활용하여:
- 더 깊이 있는 심리적 분석을 제공하세요
- 복잡한 감정의 뉘앙스를 섬세하게 다루세요  
- 논리적이면서도 감정적으로 공감할 수 있는 조언을 하세요
- 상황의 맥락을 종합적으로 고려한 통찰을 제공하세요
''';

    switch (category) {
      case ConsultationCategory.flirting:
        return '''$basePrompt
        
특히 "썸" 단계의 애매한 관계에 대한 상담을 담당합니다.
- 상대방의 심리와 행동 패턴 분석
- 미묘한 신호들의 의미 해석
- 자연스러운 관계 발전 전략
- 거절당할 위험을 최소화하는 접근법
등에 대해 깊이 있게 조언하세요.
''';

      case ConsultationCategory.dating:
        return '''$basePrompt
        
연인 관계의 복잡한 역학에 대한 상담을 담당합니다.
- 관계 내 권력균형과 의사소통 패턴 분석
- 갈등의 근본적 원인과 해결 방안
- 각자의 애착유형과 관계에 미치는 영향
- 장기적인 관계 발전을 위한 전략
등에 대해 심층적으로 조언하세요.
''';

      case ConsultationCategory.breakup:
        return '''$basePrompt
        
이별의 심리적 과정과 회복에 대한 상담을 담당합니다.
- 상실의 5단계와 개인별 회복 과정 분석
- 자존감 회복과 정체성 재구성 방법
- 트라우마 처리와 건강한 closure 방법
- 미래 관계를 위한 인사이트 도출
등에 대해 치유 중심의 조언을 하세요.
''';

      case ConsultationCategory.reconciliation:
        return '''$basePrompt
        
재회의 가능성과 건강성에 대한 상담을 담당합니다.
- 관계 종료 원인의 객관적 분석
- 개인의 성장과 변화 가능성 평가
- 재회 시도의 타이밍과 방법론
- 같은 문제 재발 방지를 위한 구체적 계획
등에 대해 현실적이면서도 희망적인 조언을 하세요.
''';
    }
  }

  List<Map<String, String>> _buildMessages(
    String userMessage,
    List<ChatMessage>? conversationHistory,
  ) {
    List<Map<String, String>> messages = [];

    // 최근 대화 이력 추가 (최대 8개)
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      final recentHistory = conversationHistory
          .where((msg) => msg.type != MessageType.ai || msg.content.isNotEmpty)
          .take(8)
          .toList();

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.type == MessageType.user ? 'user' : 'assistant',
          'content': msg.content,
        });
      }
    }

    // 현재 사용자 메시지 추가
    messages.add({
      'role': 'user', 
      'content': userMessage,
    });

    return messages;
  }

  // Claude API 키 유효성 검사
  Future<bool> validateApiKey() async {
    try {
      final response = await _dio.post('/messages', data: {
        'model': AIModel.claude.modelId,
        'max_tokens': 10,
        'messages': [
          {'role': 'user', 'content': 'Hi'}
        ],
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Claude의 대화 능력 테스트
  Future<String> testConnection() async {
    try {
      final response = await generateResponse(
        userMessage: '안녕하세요, 테스트입니다.',
        category: ConsultationCategory.flirting,
      );
      return response;
    } catch (e) {
      throw Exception('Claude 연결 테스트 실패: $e');
    }
  }
}