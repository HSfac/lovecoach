import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/ai_model.dart';
import '../../../../shared/providers/ai_model_provider.dart';
import '../../../../shared/widgets/custom_button.dart';

class AISettingsScreen extends ConsumerStatefulWidget {
  const AISettingsScreen({super.key});

  @override
  ConsumerState<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends ConsumerState<AISettingsScreen> {
  bool _isTesting = false;
  String? _testResult;

  @override
  Widget build(BuildContext context) {
    final selectedModel = ref.watch(selectedAIModelProvider);
    final availableModels = ref.watch(availableAIModelsProvider);
    final comparisons = ref.watch(aiModelComparisonProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      appBar: AppBar(
        title: const Text('AI 설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.backgroundStart,
              AppTheme.backgroundEnd,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              _buildHeader(),
              const SizedBox(height: 32),
              
              // 현재 선택된 AI
              _buildCurrentSelection(selectedModel),
              const SizedBox(height: 32),
              
              // AI 모델 선택
              _buildAIModelSelection(selectedModel, availableModels),
              const SizedBox(height: 32),
              
              // AI 모델 비교
              _buildAIComparison(comparisons),
              const SizedBox(height: 32),
              
              // 연결 테스트
              _buildConnectionTest(),
              const SizedBox(height: 20),
              
              // 테스트 결과
              if (_testResult != null) _buildTestResult(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentColor, AppTheme.primaryColor],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'AI 상담사 설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '사용할 AI 모델을 선택하여\n상담 경험을 맞춤화하세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSelection(AIModel selectedModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              selectedModel.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '현재 선택된 AI',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedModel.displayName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  selectedModel.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.calmColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '활성화',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIModelSelection(AIModel selectedModel, AsyncValue<Map<AIModel, bool>> availableModels) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI 모델 선택',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        availableModels.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('모델 확인 중 오류: $error'),
          data: (models) => Column(
            children: AIModel.values.map((model) {
              final isAvailable = models[model] ?? false;
              final isSelected = selectedModel == model;
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildModelCard(model, isAvailable, isSelected),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildModelCard(AIModel model, bool isAvailable, bool isSelected) {
    return InkWell(
      onTap: isAvailable ? () => _selectModel(model) : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAvailable ? AppTheme.accentColor : Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                model.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        model.displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? AppTheme.textPrimary : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'API 키 필요',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isAvailable ? AppTheme.textSecondary : Colors.grey[500],
                    ),
                  ),
                  Text(
                    'by ${model.provider}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIComparison(List<AIModelComparison> comparisons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI 모델 비교',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        ...comparisons.map((comparison) => _buildComparisonCard(comparison)),
      ],
    );
  }

  Widget _buildComparisonCard(AIModelComparison comparison) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(comparison.model.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                comparison.model.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // 장점
          const Text(
            '장점:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.calmColor,
            ),
          ),
          const SizedBox(height: 4),
          ...comparison.pros.map((pro) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppTheme.calmColor)),
                Expanded(
                  child: Text(
                    pro,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 8),
          
          // 단점
          const Text(
            '단점:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.angryColor,
            ),
          ),
          const SizedBox(height: 4),
          ...comparison.cons.map((con) => Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: AppTheme.angryColor)),
                Expanded(
                  child: Text(
                    con,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          )),
          
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundStart,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.recommend, size: 16, color: AppTheme.accentColor),
                const SizedBox(width: 8),
                Text(
                  '적합한 상황: ${comparison.bestFor}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionTest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '연결 테스트',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '선택한 AI 모델과의 연결을 테스트해보세요',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: _isTesting ? '테스트 중...' : 'AI 연결 테스트',
          onPressed: _isTesting ? null : _testConnection,
          isLoading: _isTesting,
        ),
      ],
    );
  }

  Widget _buildTestResult() {
    final isSuccess = !_testResult!.contains('실패') && !_testResult!.contains('오류');
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSuccess ? AppTheme.calmColor.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSuccess ? AppTheme.calmColor : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? AppTheme.calmColor : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _testResult!,
              style: TextStyle(
                color: isSuccess ? AppTheme.textPrimary : Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectModel(AIModel model) async {
    await ref.read(selectedAIModelProvider.notifier).selectModel(model);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${model.displayName}이(가) 선택되었습니다'),
          backgroundColor: AppTheme.calmColor,
        ),
      );
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      final isConnected = await ref.read(selectedAIModelProvider.notifier).testSelectedModel();
      
      setState(() {
        _testResult = isConnected 
            ? '✅ 연결 성공! AI가 정상적으로 작동합니다.'
            : '❌ 연결 실패. API 키를 확인해주세요.';
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ 테스트 실패: $e';
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }
}