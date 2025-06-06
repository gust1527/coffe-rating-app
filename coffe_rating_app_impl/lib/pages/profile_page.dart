import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/domain/entities/standard_user.dart';
import 'package:coffe_rating_app_impl/domain/entities/badge.dart' as coffee_badges;
import 'package:coffe_rating_app_impl/core/widgets/auth/login_form.dart';
import 'package:coffe_rating_app_impl/core/widgets/auth/signup_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NordicColors.background,
      body: SafeArea(
        child: Consumer<AuthStrategy>(
          builder: (context, authStrategy, child) {
            if (authStrategy.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(NordicColors.caramel),
                ),
              );
            }

            if (!authStrategy.isAuthenticated || authStrategy.currentUser == null) {
              return _buildNotLoggedInState();
            }

            final user = authStrategy.currentUser as StandardUser;
            return _buildProfileContent(user);
          },
        ),
      ),
    );
  }

  Widget _buildNotLoggedInState() {
    return Column(
      children: [
        // Header
        _buildHeader(),
        
        // Welcome content
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(NordicSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.coffee,
                    size: 80,
                    color: NordicColors.caramel,
                  ),
                  const SizedBox(height: NordicSpacing.lg),
                  Text(
                    'Welcome to Nordic Bean',
                    style: NordicTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NordicSpacing.md),
                  Text(
                    'Join our community of coffee enthusiasts',
                    style: NordicTypography.bodyLarge.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NordicSpacing.xl),
                  
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _showLoginForm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NordicColors.caramel,
                        foregroundColor: NordicColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.button),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Log In',
                        style: NordicTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: NordicSpacing.md),
                  
                  // Sign up button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => _showSignupForm(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NordicColors.textPrimary,
                        side: const BorderSide(
                          color: NordicColors.caramel,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.button),
                        ),
                      ),
                      child: Text(
                        'Create Account',
                        style: NordicTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLoginForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: LoginForm(
          onClose: () => Navigator.of(context).pop(),
          onSwitchToSignup: () {
            Navigator.of(context).pop();
            _showSignupForm();
          },
        ),
      ),
    );
  }

  void _showSignupForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SignupForm(
          onClose: () => Navigator.of(context).pop(),
          onSwitchToLogin: () {
            Navigator.of(context).pop();
            _showLoginForm();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(StandardUser user) {
    return Column(
      children: [
        // Header
        _buildHeader(),
        
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile section
                _buildProfileSection(user),
                
                // Statistics section
                _buildStatisticsSection(user),
                
                // Badges section
                _buildBadgesSection(user),
                
                // Settings section
                _buildSettingsSection(user),
                
                const SizedBox(height: NordicSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: NordicColors.textPrimary,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Profile',
              style: NordicTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Space for symmetry
        ],
      ),
    );
  }

  Widget _buildProfileSection(StandardUser user) {
    return Padding(
      padding: const EdgeInsets.all(NordicSpacing.md),
      child: Column(
        children: [
          // Profile picture and info
          Column(
            children: [
              // Profile picture
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(NordicBorderRadius.large),
                  border: Border.all(
                    color: NordicColors.divider,
                    width: 2,
                  ),
                ),
                child: user.hasAvatar
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(NordicBorderRadius.large - 2),
                        child: Image.network(
                          user.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(user),
                        ),
                      )
                    : _buildAvatarFallback(user),
              ),
              
              const SizedBox(height: NordicSpacing.lg),
              
              // User info
              Column(
                children: [
                  Text(
                    user.displayName,
                    style: NordicTypography.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: NordicSpacing.xs),
                  Text(
                    '@${user.username}',
                    style: NordicTypography.bodyLarge.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (user.location != null) ...[
                    const SizedBox(height: NordicSpacing.xs),
                    Text(
                      user.location!,
                      style: NordicTypography.bodyLarge.copyWith(
                        color: NordicColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarFallback(StandardUser user) {
    return Container(
      decoration: BoxDecoration(
        color: NordicColors.surface,
        borderRadius: BorderRadius.circular(NordicBorderRadius.large - 2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NordicColors.primaryBrown.withOpacity(0.1),
            NordicColors.caramel.withOpacity(0.2),
          ],
        ),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: NordicTypography.displayMedium.copyWith(
            color: NordicColors.primaryBrown,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(StandardUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
      child: Row(
        children: [
          _buildStatCard(
            title: 'Beans Rated',
            value: user.beansRated.toString(),
          ),
          const SizedBox(width: NordicSpacing.md),
          _buildStatCard(
            title: 'Top Brews',
            value: user.topBrews.toString(),
          ),
          const SizedBox(width: NordicSpacing.md),
          _buildStatCard(
            title: 'Favorite Roasters',
            value: user.favoriteRoasters.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(NordicSpacing.md),
        decoration: BoxDecoration(
          color: NordicColors.background,
          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
          border: Border.all(
            color: NordicColors.divider,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: NordicTypography.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: NordicSpacing.xs),
            Text(
              title,
              style: NordicTypography.bodyMedium.copyWith(
                color: NordicColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesSection(StandardUser user) {
    final userBadges = user.badges.map((badgeId) {
      try {
        return coffee_badges.Badge.predefined(badgeId);
      } catch (e) {
        return null;
      }
    }).where((badge) => badge != null).cast<coffee_badges.Badge>().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NordicSpacing.md,
            NordicSpacing.xl,
            NordicSpacing.md,
            NordicSpacing.md,
          ),
          child: Text(
            'Badges',
            style: NordicTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        if (userBadges.isEmpty)
          Padding(
            padding: const EdgeInsets.all(NordicSpacing.md),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 48,
                    color: NordicColors.textSecondary,
                  ),
                  const SizedBox(height: NordicSpacing.md),
                  Text(
                    'No badges earned yet',
                    style: NordicTypography.bodyLarge.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: NordicSpacing.sm),
                  Text(
                    'Start rating coffee beans to earn your first badge!',
                    style: NordicTypography.bodyMedium.copyWith(
                      color: NordicColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
              itemCount: userBadges.length,
              itemBuilder: (context, index) {
                final badge = userBadges[index];
                return Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    right: index < userBadges.length - 1 ? NordicSpacing.md : 0,
                  ),
                  child: _buildBadgeItem(badge),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildBadgeItem(coffee_badges.Badge badge) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(NordicBorderRadius.large),
            border: Border.all(
              color: NordicColors.divider,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NordicBorderRadius.large - 1),
            child: Image.network(
              badge.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: BoxDecoration(
                  color: NordicColors.surface,
                  borderRadius: BorderRadius.circular(NordicBorderRadius.large - 1),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: NordicColors.caramel,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: NordicSpacing.sm),
        Text(
          badge.name,
          style: NordicTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(StandardUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            NordicSpacing.md,
            NordicSpacing.xl,
            NordicSpacing.md,
            NordicSpacing.md,
          ),
          child: Text(
            'Settings',
            style: NordicTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        _buildSettingsItem(
          title: 'Notifications',
          subtitle: 'Receive coffee updates',
          trailing: Switch(
            value: user.getPreference<bool>('notifications') ?? true,
            onChanged: (value) {
              _updatePreference('notifications', value);
            },
            activeColor: NordicColors.caramel,
          ),
        ),
        
        _buildSettingsItem(
          title: 'Public Profile',
          subtitle: 'Make your profile visible to others',
          trailing: Switch(
            value: user.getPreference<bool>('public_profile') ?? true,
            onChanged: (value) {
              _updatePreference('public_profile', value);
            },
            activeColor: NordicColors.caramel,
          ),
        ),
        
        const SizedBox(height: NordicSpacing.lg),
        
        // Logout button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: NordicColors.error,
                side: const BorderSide(color: NordicColors.error),
                padding: const EdgeInsets.symmetric(vertical: NordicSpacing.md),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: NordicSpacing.md,
        vertical: NordicSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NordicTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: NordicTypography.bodyMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  void _updatePreference(String key, dynamic value) {
    final authStrategy = Provider.of<AuthStrategy>(context, listen: false);
    final currentUser = authStrategy.currentUser as StandardUser;
    
    final newPreferences = Map<String, dynamic>.from(currentUser.preferences ?? {});
    newPreferences[key] = value;
    
    authStrategy.updateProfile(preferences: newPreferences).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update preference: $error'),
          backgroundColor: NordicColors.error,
        ),
      );
    });
  }

  void _logout() async {
    final authStrategy = Provider.of<AuthStrategy>(context, listen: false);
    
    try {
      await authStrategy.logout();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out'),
            backgroundColor: NordicColors.success,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $error'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    }
  }
} 