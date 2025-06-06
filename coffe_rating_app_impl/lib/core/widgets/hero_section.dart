import 'package:flutter/material.dart';
import 'package:coffe_rating_app_impl/core/theme/nordic_theme.dart';

class HeroSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? backgroundImageUrl;

  const HeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onButtonPressed,
    this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: NordicSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(NordicBorderRadius.large),
        child: Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background image
              _buildBackgroundImage(),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(NordicSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Title
                    Text(
                      title,
                      style: NordicTypography.displayMedium.copyWith(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    
                    const SizedBox(height: NordicSpacing.sm),
                    
                    // Subtitle
                    Text(
                      subtitle,
                      style: NordicTypography.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    
                    const SizedBox(height: NordicSpacing.lg),
                    
                    // Action button
                    ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NordicColors.caramel,
                        foregroundColor: NordicColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: NordicSpacing.xl,
                          vertical: NordicSpacing.md,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(NordicBorderRadius.button),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: NordicTypography.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

  Widget _buildBackgroundImage() {
    if (backgroundImageUrl != null && backgroundImageUrl!.isNotEmpty) {
      return Positioned.fill(
        child: Image.network(
          backgroundImageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultBackground(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultBackground();
          },
        ),
      );
    }
    return _buildDefaultBackground();
  }

  Widget _buildDefaultBackground() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              NordicColors.primaryBrown.withOpacity(0.8),
              NordicColors.coffeeBean.withOpacity(0.9),
              NordicColors.espresso,
            ],
          ),
        ),
        child: CustomPaint(
          painter: CoffeeBeanPatternPainter(),
        ),
      ),
    );
  }
}

class CoffeeBeanPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw scattered coffee bean shapes
    for (int i = 0; i < 20; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 73) % size.height;
      
      _drawCoffeeBean(canvas, paint, Offset(x, y), 12 + (i % 8));
    }
  }

  void _drawCoffeeBean(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    
    // Coffee bean shape (simplified oval with a line through the middle)
    final rect = Rect.fromCenter(
      center: center,
      width: size,
      height: size * 1.4,
    );
    
    path.addOval(rect);
    canvas.drawPath(path, paint);
    
    // Center line
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.4),
      Offset(center.dx, center.dy + size * 0.4),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 