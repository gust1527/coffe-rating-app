import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback? onSwitchToLogin;
  final VoidCallback? onClose;

  const SignupForm({
    super.key,
    this.onSwitchToLogin,
    this.onClose,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authStrategy = Provider.of<AuthStrategy>(context, listen: false);
    
    try {
      await authStrategy.createUser(
        email: _emailController.text.trim(),
        name: _emailController.text.split('@')[0], // Use email prefix as name for now
        username: _emailController.text.split('@')[0], // Use email prefix as username for now
        password: _passwordController.text,
      );
      
      if (mounted && widget.onClose != null) {
        widget.onClose!();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
            backgroundColor: NordicColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStrategy>(
      builder: (context, authStrategy, child) {
        return Container(
          decoration: const BoxDecoration(
            color: NordicColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(NordicBorderRadius.large),
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with close button
                  Padding(
                    padding: const EdgeInsets.all(NordicSpacing.md),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: widget.onClose,
                          icon: const Icon(
                            Icons.close,
                            color: NordicColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.only(
                      left: NordicSpacing.md,
                      right: NordicSpacing.md,
                      bottom: NordicSpacing.lg,
                      top: NordicSpacing.sm,
                    ),
                    child: Text(
                      'Create Account',
                      style: NordicTypography.headlineMedium.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Email field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NordicSpacing.md,
                      vertical: NordicSpacing.sm,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: NordicColors.textSecondary,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: NordicColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(NordicSpacing.md),
                      ),
                      style: const TextStyle(
                        color: NordicColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NordicSpacing.md,
                      vertical: NordicSpacing.sm,
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: NordicColors.textSecondary,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: NordicColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(NordicSpacing.md),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                          icon: Icon(
                            _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                            color: NordicColors.textSecondary,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: NordicColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Confirm Password field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: NordicSpacing.md,
                      vertical: NordicSpacing.sm,
                    ),
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmPasswordObscured,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(
                          color: NordicColors.textSecondary,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: NordicColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(NordicSpacing.md),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                            });
                          },
                          icon: Icon(
                            _isConfirmPasswordObscured ? Icons.visibility : Icons.visibility_off,
                            color: NordicColors.textSecondary,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: NordicColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Sign up button
                  Padding(
                    padding: const EdgeInsets.all(NordicSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authStrategy.isLoading ? null : _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NordicColors.caramel,
                          foregroundColor: NordicColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: authStrategy.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    NordicColors.textPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: NordicTypography.labelLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Switch to login
                  Padding(
                    padding: const EdgeInsets.only(
                      left: NordicSpacing.md,
                      right: NordicSpacing.md,
                      bottom: NordicSpacing.lg,
                      top: NordicSpacing.sm,
                    ),
                    child: TextButton(
                      onPressed: widget.onSwitchToLogin,
                      child: Text(
                        "Already have an account? Log in",
                        style: NordicTypography.bodyMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: NordicColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: NordicSpacing.sm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 