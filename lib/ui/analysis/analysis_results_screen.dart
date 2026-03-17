import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/food_analysis.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/ai/ai_service_factory.dart';
import '../../services/image_service.dart';

class AnalysisResultsScreen extends ConsumerStatefulWidget {
  final String imagePath;
  final Map<String, dynamic>? analysisResult;

  const AnalysisResultsScreen({
    super.key,
    required this.imagePath,
    this.analysisResult,
  });

  @override
  ConsumerState<AnalysisResultsScreen> createState() =>
      _AnalysisResultsScreenState();
}

class _AnalysisResultsScreenState
    extends ConsumerState<AnalysisResultsScreen> {
  FoodAnalysis? _analysis;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String _selectedMealType = 'other';

  @override
  void initState() {
    super.initState();
    if (widget.analysisResult != null) {
      _analysis = FoodAnalysis.fromJson(widget.analysisResult!);
      _isLoading = false;
    } else {
      _analyzeImage();
    }
    _selectedMealType = _guessMealType();
  }

  String _guessMealType() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'breakfast';
    if (hour < 15) return 'lunch';
    if (hour < 17) return 'snack';
    return 'dinner';
  }

  Future<void> _analyzeImage() async {
    try {
      final aiService = await ref.read(aiServiceProvider.future);
      if (aiService == null) {
        setState(() {
          _error = 'No AI provider configured. Go to Settings to add an API key.';
          _isLoading = false;
        });
        return;
      }

      final imageService = ref.read(imageServiceProvider);
      final bytes = await imageService.getCompressedImageBytes(widget.imagePath);
      final result = await aiService.analyzeFood(bytes);

      if (mounted) {
        setState(() {
          _analysis = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Analysis failed: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmAndLog() async {
    if (_analysis == null || _isSaving) return;
    setState(() => _isSaving = true);

    try {
      final imageService = ref.read(imageServiceProvider);
      final savedPath = await imageService.saveImage(widget.imagePath);

      final settingsRepo = ref.read(settingsRepositoryProvider);
      final provider = await settingsRepo.getActiveAiProvider();

      final mealRepo = ref.read(mealRepositoryProvider);
      await mealRepo.saveMeal(
        imagePath: savedPath,
        analysis: _analysis!,
        mealType: _selectedMealType,
        aiProvider: provider.name,
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildResults(isDark),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing your food...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI is identifying items and estimating calories',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    _analyzeImage();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(bool isDark) {
    final analysis = _analysis!;

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Top bar
              SliverAppBar(
                pinned: true,
                backgroundColor: isDark
                    ? Colors.black.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.8),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                title: const Text('AI Analysis'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ],
              ),

              // Hero image
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: AppColors.primary, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    'AI Scanned Successfully',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Total calories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Text(
                        'ESTIMATED TOTAL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${analysis.totalCalories} ',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                fontFamily: 'Inter',
                              ),
                            ),
                            TextSpan(
                              text: 'kcal',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiaryLight,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Analysis card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark.withValues(alpha: 0.5)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Analysis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...analysis.foods.asMap().entries.map((entry) {
                          final i = entry.key;
                          final food = entry.value;
                          return Column(
                            children: [
                              if (i > 0)
                                Divider(
                                  color: isDark
                                      ? AppColors.borderDark.withValues(alpha: 0.5)
                                      : AppColors.borderLight.withValues(alpha: 0.5),
                                  height: 24,
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          food.name,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (food.category.isNotEmpty)
                                          Text(
                                            food.category,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark
                                                  ? AppColors.textTertiaryDark
                                                  : AppColors.textTertiaryLight,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.surfaceDark
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.borderDark
                                            : AppColors.borderLight,
                                      ),
                                    ),
                                    child: Text(
                                      food.portion,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Health feedback
              if (analysis.healthFeedback.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.05 : 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.smart_toy,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'AI SAYS...',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            analysis.healthFeedback,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Meal type selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Meal type: ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...['breakfast', 'lunch', 'snack', 'dinner'].map(
                        (type) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type[0].toUpperCase() + type.substring(1)),
                            selected: _selectedMealType == type,
                            onSelected: (s) =>
                                setState(() => _selectedMealType = type),
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _selectedMealType == type
                                  ? Colors.white
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),

        // Bottom action buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _confirmAndLog,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.task_alt),
                    label: Text(_isSaving ? 'Saving...' : 'Confirm & Log'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
