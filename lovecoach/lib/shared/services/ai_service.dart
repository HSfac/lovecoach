import 'package:dio/dio.dart';
import '../models/chat_message.dart';
import '../models/ai_model.dart';
import '../../core/config/env_config.dart';
import 'claude_service.dart';

class AIService {
  final Dio _dio = Dio();
  final ClaudeService _claudeService = ClaudeService();
  static const String _baseUrl = 'https://api.openai.com/v1';

  AIService() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Authorization': 'Bearer ${EnvConfig.openaiApiKey}',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  Future<String> generateResponse({
    required String userMessage,
    required ConsultationCategory category,
    List<ChatMessage>? conversationHistory,
    AIModel? aiModel,
  }) async {
    try {
      final selectedModel = aiModel ?? AIModel.fromString(EnvConfig.defaultAiModel);
      
      // API 키가 없는 경우 데모 응답 반환
      if (EnvConfig.openaiApiKey.isEmpty || EnvConfig.openaiApiKey == 'sk-your-actual-openai-key') {
        return _getDemoResponse(userMessage, category);
      }
    
      switch (selectedModel) {
        case AIModel.claude:
          return await _claudeService.generateResponse(
            userMessage: userMessage,
            category: category,
            conversationHistory: conversationHistory,
          );
        case AIModel.openai:
          return await _generateOpenAIResponse(
            userMessage: userMessage,
            category: category,
            conversationHistory: conversationHistory,
          );
      }
    } catch (e) {
      return _getDemoResponse(userMessage, category);
    }
  }

  Future<String> _generateOpenAIResponse({
    required String userMessage,
    required ConsultationCategory category,
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      final systemPrompt = _getSystemPrompt(category);
      final messages = _buildMessages(systemPrompt, userMessage, conversationHistory);

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
          'presence_penalty': 0.1,
          'frequency_penalty': 0.1,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception('API 호출 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('OpenAI API 키가 유효하지 않습니다.');
      } else if (e.response?.statusCode == 429) {
        throw Exception('API 사용량 한도를 초과했습니다. 잠시 후 다시 시도해주세요.');
      } else {
        throw Exception('네트워크 오류가 발생했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('AI 응답 생성 중 오류가 발생했습니다: $e');
    }
  }

  String _getSystemPrompt(ConsultationCategory category) {
    const basePrompt = '''
당신은 전문 연애 상담사 "러브코치"입니다. 
사용자의 연애 고민을 듣고 따뜻하고 공감적인 조언을 제공합니다.
답변은 한국어로 하고, 친근하면서도 전문적인 톤을 유지하세요.
구체적이고 실용적인 조언을 제공하되, 상황을 단정하지 말고 다양한 관점을 제시하세요.
답변은 2-3문단 정도로 적절한 길이를 유지하세요.
''';

    switch (category) {
      case ConsultationCategory.flirting:
        return '''$basePrompt
        
특히 "썸" 단계의 애매한 관계에 대한 상담을 담당합니다.
- 상대방의 관심도를 파악하는 방법
- 자연스러운 어필 방법
- 썸에서 연애로 발전시키는 방법
- 밀당의 적절한 선 찾기
등에 대해 조언하세요.
''';

      case ConsultationCategory.dating:
        return '''$basePrompt
        
연인 관계 유지와 발전에 대한 상담을 담당합니다.
- 연인과의 소통 방법
- 갈등 해결 방안
- 관계 발전 방법
- 서로에 대한 이해 증진
등에 대해 조언하세요.
''';

      case ConsultationCategory.breakup:
        return '''$basePrompt
        
이별 후 마음의 치유와 회복에 대한 상담을 담당합니다.
- 상실감과 슬픔 극복
- 자존감 회복 방법
- 새로운 시작을 위한 준비
- 감정 정리와 성장
등에 대해 따뜻하고 위로가 되는 조언을 하세요.
''';

      case ConsultationCategory.reconciliation:
        return '''$basePrompt
        
헤어진 연인과의 재회에 대한 상담을 담당합니다.
- 재회 가능성 객관적 판단
- 자기 반성과 성장
- 상대방과의 건강한 소통 방법
- 같은 문제 반복 방지 방안
등에 대해 신중하고 균형잡힌 조언을 하세요.
''';
    }
  }

  List<Map<String, String>> _buildMessages(
    String systemPrompt,
    String userMessage,
    List<ChatMessage>? conversationHistory,
  ) {
    List<Map<String, String>> messages = [
      {'role': 'system', 'content': systemPrompt},
    ];

    // 최근 대화 이력 추가 (최대 10개)
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      final recentHistory = conversationHistory
          .where((msg) => msg.type != MessageType.ai || msg.content.isNotEmpty)
          .take(10)
          .toList();

      for (final msg in recentHistory) {
        messages.add({
          'role': msg.type == MessageType.user ? 'user' : 'assistant',
          'content': msg.content,
        });
      }
    }

    // 현재 사용자 메시지 추가
    messages.add({'role': 'user', 'content': userMessage});

    return messages;
  }

  // API 키 유효성 검사
  Future<bool> validateApiKey({AIModel? aiModel}) async {
    final selectedModel = aiModel ?? AIModel.fromString(EnvConfig.defaultAiModel);
    
    switch (selectedModel) {
      case AIModel.claude:
        return await _claudeService.validateApiKey();
      case AIModel.openai:
        try {
          final response = await _dio.get('/models');
          return response.statusCode == 200;
        } catch (e) {
          return false;
        }
    }
  }

  // 두 AI 모델 모두 사용 가능한지 체크
  Future<Map<AIModel, bool>> checkAvailableModels() async {
    final results = <AIModel, bool>{};
    
    for (final model in AIModel.values) {
      results[model] = await validateApiKey(aiModel: model);
    }
    
    return results;
  }

  // 모델별 연결 테스트
  Future<String> testConnection({AIModel? aiModel}) async {
    final selectedModel = aiModel ?? AIModel.fromString(EnvConfig.defaultAiModel);
    
    try {
      final response = await generateResponse(
        userMessage: '안녕하세요, 연결 테스트입니다.',
        category: ConsultationCategory.flirting,
        aiModel: selectedModel,
      );
      return response;
    } catch (e) {
      throw Exception('${selectedModel.displayName} 연결 테스트 실패: $e');
    }
  }

  // 사용량 체크 (참고용)
  Future<Map<String, dynamic>?> getUsage() async {
    try {
      final response = await _dio.get('/usage');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  String _getDemoResponse(String userMessage, ConsultationCategory category) {
    final responses = {
      ConsultationCategory.flirting: [
        '안녕하세요! 썸 단계에서는 서로의 관심을 확인하는 것이 중요해요. 상대방의 반응을 잘 살펴보시면서 자연스럽게 다가가시는 것을 추천드려요. 💕',
        '썸 관계에서는 적당한 거리감이 매력적일 수 있어요. 너무 급하게 다가가기보다는 상대방의 페이스에 맞춰 천천히 발전시켜보세요!',
        '상대방에게 관심을 보이되, 자신만의 매력도 잃지 마세요. 균형감 있는 어필이 가장 효과적이에요! 😊'
      ],
      ConsultationCategory.dating: [
        '연애에서 가장 중요한 것은 소통이에요. 서로의 마음을 솔직하게 나누고 이해하려고 노력하시는 것이 좋을 것 같아요.',
        '연인 관계에서는 서로를 존중하면서도 자신다움을 유지하는 것이 중요해요. 건강한 관계를 만들어가시길 응원해요! ❤️',
        '갈등이 생겼을 때는 감정적으로 반응하기보다는 차분히 대화해보세요. 서로의 입장을 이해하려는 노력이 필요해요.'
      ],
      ConsultationCategory.breakup: [
        '이별의 아픔은 시간이 치유해줄 거예요. 지금은 힘드시겠지만, 자신을 돌보는 시간을 갖는 것이 중요해요.',
        '슬픔을 억누르지 마세요. 충분히 슬퍼하고, 주변 사람들의 도움을 받으시는 것도 좋은 방법이에요. 💙',
        '이별을 통해 성장할 수 있는 기회로 생각해보세요. 앞으로 더 좋은 만남이 기다리고 있을 거예요!'
      ],
      ConsultationCategory.reconciliation: [
        '재회를 생각하신다면, 먼저 이별의 원인을 객관적으로 분석해보는 것이 중요해요. 같은 문제가 반복되지 않도록 준비가 필요해요.',
        '상대방의 마음도 중요하지만, 본인의 진짜 마음부터 확인해보세요. 외로움 때문인지, 진정한 사랑 때문인지 생각해보시길 바라요.',
        '재회를 원한다면 성급하게 접근하기보다는 시간을 두고 자연스럽게 다가가시는 것을 추천해요. 🤝'
      ],
    };

    final categoryResponses = responses[category] ?? responses[ConsultationCategory.dating]!;
    final randomResponse = categoryResponses[userMessage.length % categoryResponses.length];
    
    return '''$randomResponse

💡 현재 데모 모드로 실행 중입니다. 
실제 AI 상담을 받으시려면 OpenAI API 키를 설정해주세요!''';
  }
}