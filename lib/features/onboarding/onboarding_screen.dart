import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/database_provider.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedAge = 18;
  String _selectedDifficulty = 'medium';

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: 'assets/images/mascot/chicky_happy.png',
      title: 'Welcome to ChickRoad City!',
      description: 'Learn road safety rules with Chicky, your friendly driving instructor!',
      backgroundColor: AppColors.primaryDark,
    ),
    OnboardingPage(
      image: 'assets/images/mascot/chicky_thinking.png',
      title: 'Master Road Signs',
      description: 'Learn universal road signs and traffic rules used worldwide!',
      backgroundColor: AppColors.primaryDark,
    ),
    OnboardingPage(
      image: 'assets/images/mascot/chicky_driving.png',
      title: 'Practice & Take Exams',
      description: 'Quiz yourself by category or take timed exams to test your knowledge!',
      backgroundColor: AppColors.primaryDark,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final db = ref.read(databaseHelperProvider);
    
    // Initialize user account (creates first streak entry)
    await db.initializeUserAccount();
    
    // Save user settings
    await settingsNotifier.completeOnboarding(_selectedAge, _selectedDifficulty);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length) { // Changed from _pages.length - 1
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.surface,
                  ],
                ),
              ),
            ),
          ),
          
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length + 1, // +1 for settings page
            itemBuilder: (context, index) {
              if (index < _pages.length) {
                return _buildPage(_pages[index]);
              } else {
                return _buildSettingsPage();
              }
            },
          ),
          
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: AppTypography.buttonMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length + 1, // +1 for settings page
                    (index) => _buildPageIndicator(index),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                // Next/Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryYellow,
                        foregroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        _currentPage == _pages.length ? 'Get Started' : 'Next',
                        style: AppTypography.buttonLarge.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Mascot image
          Image.asset(
            page.image,
            width: 250,
            height: 250,
            errorBuilder: (_, __, ___) => Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.secondaryYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          
          // Title
          Text(
            page.title,
            style: AppTypography.h1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Description
          Text(
            page.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondaryYellow : AppColors.textSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Chicky celebrate
          Image.asset(
            'assets/images/mascot/chicky_celebrate.png',
            width: 200,
            height: 200,
            errorBuilder: (_, __, ___) => Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.secondaryYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration, size: 100, color: Colors.white),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            'Almost There!',
            style: AppTypography.h1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 32,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Tell us a bit about yourself',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xxl),
          
          // Age selector
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Age',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$_selectedAge years old',
                      style: AppTypography.h3.copyWith(color: AppColors.secondaryYellow),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _selectedAge > 10 ? () {
                            setState(() => _selectedAge--);
                          } : null,
                          icon: const Icon(Icons.remove_circle),
                          color: AppColors.secondaryYellow,
                        ),
                        IconButton(
                          onPressed: _selectedAge < 100 ? () {
                            setState(() => _selectedAge++);
                          } : null,
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.secondaryYellow,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Difficulty selector
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Difficulty Level',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildDifficultyButton('Easy', 'easy'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildDifficultyButton('Medium', 'medium'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildDifficultyButton('Hard', 'hard'),
                  ],
                ),
              ],
            ),
          ),
          
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton(String label, String value) {
    final isSelected = _selectedDifficulty == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDifficulty = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondaryYellow : AppColors.primaryDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.secondaryYellow : AppColors.textSecondary.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final Color backgroundColor;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });
}
