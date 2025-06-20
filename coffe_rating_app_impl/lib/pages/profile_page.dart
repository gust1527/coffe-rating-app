import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    CoffeeLogger.ui('Initializing profile page');
  }

  @override
  void dispose() {
    CoffeeLogger.ui('Disposing profile page');
    _disposed = true;
    super.dispose();
  }

  Future<void> _handleSignOut() async {
    if (_disposed) return;
    CoffeeLogger.ui('User requested sign out');
    setState(() {
      _isLoading = true;
    });

    try {
      final authStrategy = Provider.of<AuthStrategy>(context, listen: false);
      await authStrategy.logout();
      CoffeeLogger.ui('User signed out successfully');
    } catch (e, stackTrace) {
      CoffeeLogger.error('Failed to sign out', e, stackTrace);
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    } finally {
      if (!_disposed) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStrategy>(
      builder: (context, authStrategy, child) {
        final user = authStrategy.currentUser;
        if (user == null) {
          CoffeeLogger.warning('Attempting to view profile page without authenticated user');
          return const Center(
            child: Text('Please log in to view your profile'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: _isLoading ? null : _handleSignOut,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.logout),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(NordicSpacing.lg),
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: NordicColors.caramel,
                child: Text(
                  user.name[0].toUpperCase(),
                  style: NordicTypography.headlineLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: NordicSpacing.lg),
              Text(
                user.name,
                style: NordicTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: NordicSpacing.sm),
              Text(
                user.email,
                style: NordicTypography.bodyMedium.copyWith(
                  color: NordicColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (user.location != null) ...[
                const SizedBox(height: NordicSpacing.sm),
                Text(
                  user.location!,
                  style: NordicTypography.bodyMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: NordicSpacing.xl),
              _buildStatCard(
                title: 'Total Ratings',
                value: '0', // TODO: Implement ratings count
                icon: Icons.star_outline,
              ),
              const SizedBox(height: NordicSpacing.md),
              _buildStatCard(
                title: 'Favorite Bean',
                value: 'None yet', // TODO: Implement favorite bean
                icon: Icons.favorite_outline,
              ),
              const SizedBox(height: NordicSpacing.md),
              _buildStatCard(
                title: 'Member Since',
                value: 'March 2024', // TODO: Implement join date
                icon: Icons.calendar_today_outlined,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(NordicSpacing.lg),
      decoration: BoxDecoration(
        color: NordicColors.surface,
        borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: NordicColors.caramel,
            size: 24,
          ),
          const SizedBox(width: NordicSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: NordicTypography.bodyMedium.copyWith(
                    color: NordicColors.textSecondary,
                  ),
                ),
                const SizedBox(height: NordicSpacing.xs),
                Text(
                  value,
                  style: NordicTypography.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 