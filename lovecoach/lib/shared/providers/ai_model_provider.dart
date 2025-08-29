import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ai_model.dart';
import '../services/ai_service.dart';
import '../../core/config/env_config.dart';

// AI 모델 선택 상태 관리
final selectedAIModelProvider = StateNotifierProvider<AIModelNotifier, AIModel>((ref) {
  return AIModelNotifier();
});

// 사용 가능한 AI 모델들 체크
final availableAIModelsProvider = FutureProvider<Map<AIModel, bool>>((ref) async {
  final aiService = ref.read(aiServiceProvider);
  return await aiService.checkAvailableModels();
});

class AIModelNotifier extends StateNotifier<AIModel> {
  static const String _prefKey = 'selected_ai_model';
  
  AIModelNotifier() : super(AIModel.fromString(EnvConfig.defaultAiModel)) {
    _loadSelectedModel();
  }

  Future<void> _loadSelectedModel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modelName = prefs.getString(_prefKey);
      if (modelName != null) {
        state = AIModel.fromString(modelName);
      }
    } catch (e) {
      // SharedPreferences 오류시 기본값 유지
    }
  }

  Future<void> selectModel(AIModel model) async {
    state = model;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, model.name);
    } catch (e) {
      // SharedPreferences 저장 실패는 무시 (앱 재시작시 기본값으로 복원)
    }
  }

  Future<bool> testSelectedModel() async {
    try {
      final aiService = AIService();
      await aiService.testConnection(aiModel: state);
      return true;
    } catch (e) {
      return false;
    }
  }
}

// AI 서비스 provider (기존)
final aiServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

// AI 모델 상태와 연결된 AI 서비스
final contextualAIServiceProvider = Provider<AIService>((ref) {
  return AIService();
});

// AI 모델 비교 정보 provider
final aiModelComparisonProvider = Provider<List<AIModelComparison>>((ref) {
  return [
    AIModelComparison(
      model: AIModel.openai,
      pros: [
        '빠른 응답 속도',
        '일관된 성능',
        '다양한 주제 커버',
        '상대적으로 저렴한 비용',
      ],
      cons: [
        '때로는 표면적인 답변',
        '창의성 제한',
      ],
      bestFor: '빠른 일반적인 상담',
    ),
    AIModelComparison(
      model: AIModel.claude,
      pros: [
        '깊이 있는 분석',
        '뉘앙스 있는 이해',
        '복잡한 상황 처리',
        '더 인간적인 대화',
      ],
      cons: [
        '상대적으로 느린 응답',
        '높은 비용',
      ],
      bestFor: '복잡한 심리 상담',
    ),
  ];
});

class AIModelComparison {
  final AIModel model;
  final List<String> pros;
  final List<String> cons;
  final String bestFor;

  AIModelComparison({
    required this.model,
    required this.pros,
    required this.cons,
    required this.bestFor,
  });
}