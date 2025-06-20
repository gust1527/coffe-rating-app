import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';

class LoginForm extends StatefulWidget {
  final Function(String email, String password) onSubmit;
  final VoidCallback onSignupClick;
  final bool isLoading;
  final String? error;

  const LoginForm({
    super.key,
    required this.onSubmit,
    required this.onSignupClick,
    this.isLoading = false,
    this.error,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    CoffeeLogger.ui('Initializing login form');
  }

  @override
  void dispose() {
    CoffeeLogger.ui('Disposing login form');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LoginForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error && widget.error != null) {
      CoffeeLogger.error('Login error occurred', widget.error);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      CoffeeLogger.ui('Attempting login with email: ${_emailController.text}');
      widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    } else {
      CoffeeLogger.warning('Login form validation failed');
    }
  }

  void _togglePasswordVisibility() {
    CoffeeLogger.ui('Toggling password visibility');
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              ),
            ),
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
          ),
          const SizedBox(height: NordicSpacing.md),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(NordicBorderRadius.medium),
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          if (widget.error != null) ...[
            const SizedBox(height: NordicSpacing.sm),
            Text(
              widget.error!,
              style: NordicTypography.bodyMedium.copyWith(
                color: NordicColors.error,
              ),
            ),
          ],
          const SizedBox(height: NordicSpacing.lg),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: NordicColors.caramel,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: NordicSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(NordicBorderRadius.button),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Log In'),
          ),
          const SizedBox(height: NordicSpacing.md),
          TextButton(
            onPressed: widget.onSignupClick,
            child: Text(
              'Don\'t have an account? Sign up',
              style: NordicTypography.bodyMedium.copyWith(
                color: NordicColors.caramel,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 