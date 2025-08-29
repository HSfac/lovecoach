import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/providers/auth_provider.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  int currentStep = 0;
  final PageController _pageController = PageController();
  
  // 설문 답변 저장
  String? selectedGender;
  int? selectedAge;
  String? relationshipStatus;
  List<String> interests = [];
  String? communicationStyle;
  
  bool _isLoading = true;

  final List<String> genderOptions = ['남성', '여성', '선택 안함'];
  final List<String> ageRanges = ['20대 초반', '20대 후반', '30대 초반', '30대 후반', '40대 이상'];
  final List<String> statusOptions = ['싱글', '썸', '연애중', '기타'];
  final List<String> interestOptions = ['첫만남 대화법', '데이트 플래닝', '감정 표현', '갈등 해결', '장거리 연애', '결혼 준비'];
  final List<String> communicationOptions = ['직설적', '조심스러운', '유머러스', '진지한'];

  @override
  void initState() {
    super.initState();
    _loadExistingSurveyData();
  }
  
  Future<void> _loadExistingSurveyData() async {
    try {
      final existingSurvey = await ref.read(authNotifierProvider.notifier).getSurveyData();
      if (existingSurvey != null && mounted) {
        setState(() {
          selectedGender = existingSurvey.gender;
          selectedAge = existingSurvey.ageRange;
          relationshipStatus = existingSurvey.relationshipStatus;
          interests = List.from(existingSurvey.interests);
          communicationStyle = existingSurvey.communicationStyle;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundStart,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('설문조사 데이터를 불러오는 중...'),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.backgroundStart,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundStart, AppTheme.backgroundEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 진행률 표시
              _buildProgressIndicator(),
              
              // 설문 내용
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => currentStep = index),
                  children: [
                    _buildGenderStep(),
                    _buildAgeStep(), 
                    _buildRelationshipStatusStep(),
                    _buildInterestsStep(),
                    _buildCommunicationStyleStep(),
                  ],
                ),
              ),
              
              // 하단 버튼
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: currentStep > 0 ? AppTheme.primaryColor.withOpacity(0.1) : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: currentStep > 0 ? _previousStep : null,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: currentStep > 0 ? AppTheme.primaryColor : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  '${currentStep + 1}/5',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(5, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < 4 ? 8 : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: isCompleted || isCurrent 
                          ? AppTheme.primaryColor
                          : Colors.grey[300],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              final icons = [Icons.person, Icons.cake, Icons.favorite, Icons.interests, Icons.chat];
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              
              return Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted 
                          ? AppTheme.primaryColor
                          : isCurrent 
                              ? AppTheme.primaryColor.withOpacity(0.2)
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      border: isCurrent 
                          ? Border.all(color: AppTheme.primaryColor, width: 2)
                          : null,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : icons[index],
                      size: 18,
                      color: isCompleted 
                          ? Colors.white
                          : isCurrent 
                              ? AppTheme.primaryColor
                              : Colors.grey[500],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderStep() {
    return _buildStepContainer(
      title: '성별을 알려주세요',
      subtitle: '더 맞춤화된 상담을 위해 필요해요',
      child: Column(
        children: genderOptions.map((gender) =>
          _buildOptionTile(
            title: gender,
            isSelected: selectedGender == gender,
            onTap: () => setState(() => selectedGender = gender),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildAgeStep() {
    return _buildStepContainer(
      title: '연령대를 선택해주세요',
      subtitle: '연령대별 맞춤 조언을 드릴게요',
      child: Column(
        children: ageRanges.asMap().entries.map((entry) =>
          _buildOptionTile(
            title: entry.value,
            isSelected: selectedAge == entry.key,
            onTap: () => setState(() => selectedAge = entry.key),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildRelationshipStatusStep() {
    return _buildStepContainer(
      title: '현재 연애 상태는?',
      subtitle: '상황에 맞는 조언을 드릴게요',
      child: Column(
        children: statusOptions.map((status) =>
          _buildOptionTile(
            title: status,
            isSelected: relationshipStatus == status,
            onTap: () => setState(() => relationshipStatus = status),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildInterestsStep() {
    return _buildStepContainer(
      title: '관심 있는 주제는?',
      subtitle: '여러 개 선택 가능해요 (최대 3개)',
      child: Column(
        children: interestOptions.map((interest) =>
          _buildOptionTile(
            title: interest,
            isSelected: interests.contains(interest),
            onTap: () {
              setState(() {
                if (interests.contains(interest)) {
                  interests.remove(interest);
                } else if (interests.length < 3) {
                  interests.add(interest);
                }
              });
            },
            isMultiSelect: true,
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildCommunicationStyleStep() {
    return _buildStepContainer(
      title: '선호하는 대화 스타일은?',
      subtitle: 'AI가 이 스타일로 상담해드릴게요',
      child: Column(
        children: communicationOptions.map((style) =>
          _buildOptionTile(
            title: style,
            isSelected: communicationStyle == style,
            onTap: () => setState(() => communicationStyle = style),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildStepContainer({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
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
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    bool isMultiSelect = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: AppTheme.primaryColor.withOpacity(0.1),
            highlightColor: AppTheme.primaryColor.withOpacity(0.05),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryColor.withOpacity(0.08)
                    : Colors.white,
                border: Border.all(
                  color: isSelected 
                      ? AppTheme.primaryColor
                      : Colors.grey[300]!,
                  width: isSelected ? 2.5 : 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        isMultiSelect ? 6 : 12,
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        color: isSelected 
                            ? AppTheme.primaryColor
                            : AppTheme.textPrimary,
                        fontWeight: isSelected 
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (isSelected)
                    AnimatedRotation(
                      turns: 0.125,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.primaryColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: CustomButton(
            text: currentStep == 4 ? '🎉 완료하기' : '다음 단계',
            onPressed: _canProceed() ? _nextStep : null,
          ),
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0: return selectedGender != null;
      case 1: return selectedAge != null;
      case 2: return relationshipStatus != null;
      case 3: return interests.isNotEmpty;
      case 4: return communicationStyle != null;
      default: return false;
    }
  }

  void _nextStep() {
    if (currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSurvey();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeSurvey() async {
    try {
      // 최종 완료 검증 - 더 강화된 체크
      final missingItems = <String>[];
      
      if (selectedGender == null || selectedGender!.isEmpty) {
        missingItems.add('성별');
      }
      if (selectedAge == null) {
        missingItems.add('연령대');
      }
      if (relationshipStatus == null || relationshipStatus!.isEmpty) {
        missingItems.add('연애 상태');
      }
      if (interests.isEmpty) {
        missingItems.add('관심 주제 (최소 1개)');
      }
      if (communicationStyle == null || communicationStyle!.isEmpty) {
        missingItems.add('대화 스타일');
      }
      
      if (missingItems.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('다음 항목을 완성해주세요: ${missingItems.join(', ')}'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }
      
      print('설문 저장 시도: gender=$selectedGender, age=$selectedAge, status=$relationshipStatus, interests=$interests, style=$communicationStyle');
      
      // 설문 결과를 Firebase에 저장
      final success = await ref.read(authNotifierProvider.notifier).saveSurveyData(
        gender: selectedGender!,
        ageRange: selectedAge!,
        relationshipStatus: relationshipStatus!,
        interests: List<String>.from(interests),
        communicationStyle: communicationStyle!,
      );
      
      if (success && mounted) {
        // 성공 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('설문조사가 완료되었습니다! 🎉'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // 잠시 대기 후 이동
        await Future.delayed(const Duration(milliseconds: 500));
        
        // 설문조사 완료 후 적절한 화면으로 이동
        if (mounted) {
          // 이전 화면이 프로필이면 다시 프로필로, 그렇지 않으면 카테고리로
          if (context.canPop()) {
            context.pop(); // 프로필에서 왔다면 프로필로 돌아가기
          } else {
            context.go('/category'); // 온보딩에서 왔다면 카테고리로
          }
        }
      } else if (mounted) {
        // 에러 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('설문 저장 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('설문 완료 에러: $e');
      if (mounted) {
        String errorMessage = '설문 저장 중 오류가 발생했습니다';
        if (e.toString().contains('설문조사가 완전히')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}