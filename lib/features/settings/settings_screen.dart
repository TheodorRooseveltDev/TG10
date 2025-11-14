import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/providers/database_provider.dart';
import '../../core/utils/responsive_utils.dart';
import '../splash/splash_screen.dart';
import 'webview_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _selectedAge = 18;
  String _selectedDifficulty = 'medium';
  bool _isLoading = true;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ref.read(settingsProvider.future);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedAge = settings.userAge ?? 18;
      _selectedDifficulty = settings.preferredDifficulty;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      // Request OneSignal permission first when enabling notifications
      try {
        final permission = await OneSignal.Notifications.requestPermission(true);
        // Only update state if permission was granted
        if (permission == true) {
          setState(() {
            _notificationsEnabled = true;
          });
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('notificationsEnabled', true);
        } else {
          // Permission denied, keep switch off
          setState(() {
            _notificationsEnabled = false;
          });
        }
      } catch (e) {
        debugPrint('OneSignal permission request error: $e');
        // On error, keep switch off
        setState(() {
          _notificationsEnabled = false;
        });
      }
    } else {
      // When disabling, just update state
      setState(() {
        _notificationsEnabled = false;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', false);
    }
  }

  Future<void> _saveSettings() async {
    final db = ref.read(databaseHelperProvider);
    await db.updateUserSettings({
      'userAge': _selectedAge,
      'preferredDifficulty': _selectedDifficulty,
    });
    
    ref.invalidate(settingsProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Delete Account',
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete your account? This will erase all your progress, streaks, and achievements. This action cannot be undone.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Delete all user data
      final db = ref.read(databaseHelperProvider);
      await db.deleteAllProgress();
      
      // Reset SharedPreferences
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.clear();
      
      // Navigate back to splash/onboarding
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SplashScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ResponsiveScaffold(
        backgroundColor: AppColors.primaryDark,
        child: Scaffold(
          backgroundColor: AppColors.primaryDark,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            title: Text('Settings', style: AppTypography.h2.copyWith(color: AppColors.textPrimary)),
          ),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ResponsiveScaffold(
      backgroundColor: AppColors.primaryDark,
      child: Scaffold(
        backgroundColor: AppColors.primaryDark,
        appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: AppTypography.h2.copyWith(color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(
              'Save',
              style: AppTypography.buttonMedium.copyWith(color: AppColors.secondaryYellow),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _buildSectionHeader('Profile'),
          const SizedBox(height: AppSpacing.md),
          _buildAgeSelector(),
          const SizedBox(height: AppSpacing.md),
          _buildDifficultySelector(),
          const SizedBox(height: AppSpacing.md),
          _buildNotificationsSwitch(),
          
          const SizedBox(height: AppSpacing.xl),
          _buildSectionHeader('Legal'),
          const SizedBox(height: AppSpacing.md),
          _buildLegalButton(
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewScreen(
                    url: 'https://chickroadcity.com/privacy',
                    title: 'Privacy Policy',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildLegalButton(
            'Terms of Service',
            Icons.description_outlined,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WebViewScreen(
                    url: 'https://chickroadcity.com/terms',
                    title: 'Terms of Service',
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: AppSpacing.xl),
          _buildSectionHeader('About'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard('Version', '1.0.0'),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoCard('Developer', 'ChickRoad Team'),
          
          const SizedBox(height: AppSpacing.xl),
          _buildSectionHeader('Danger Zone'),
          const SizedBox(height: AppSpacing.md),
          _buildDeleteButton(),
          
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.h3.copyWith(
        color: AppColors.secondaryYellow,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Container(
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
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
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

  Widget _buildLegalButton(String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.secondaryYellow, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSwitch() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.secondaryYellow,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Notifications',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enable push notifications',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Switch(
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeColor: AppColors.secondaryYellow,
            activeTrackColor: AppColors.secondaryYellow.withOpacity(0.5),
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.textSecondary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Material(
      color: AppColors.accentRed.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _deleteAccount,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentRed.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: AppColors.accentRed, size: 24),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Account',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accentRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Permanently delete all your data',
                      style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
