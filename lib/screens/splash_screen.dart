// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4ECDC4),
              Color(0xFF44A08D),
              Color(0xFF3A8E7A),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Image
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
                                blurRadius: 10,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/habitez-splash-screen.png',
                                width: 120,
                                fit: BoxFit.contain,
                                // errorBuilder: (context, error, stackTrace) {
                                //   return const HabitezIcon(
                                //     size: 120,
                                //     color: Colors.white,
                                //   );
                                // },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Habitsez🔥',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Building better habits, one step at a time',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 60),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Fallback Custom Icon (same as before)
// class HabitezIcon extends StatelessWidget {
//   final double size;
//   final Color color;

//   const HabitezIcon({super.key, this.size = 80, this.color = Colors.white});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(size, size),
//       painter: HabitezIconPainter(color: color),
//     );
//   }
// }

// class HabitezIconPainter extends CustomPainter {
//   final Color color;

//   HabitezIconPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final strokePaint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 3
//       ..strokeCap = StrokeCap.round;

//     // Same custom icon implementation as before
//     final barWidth = size.width * 0.12;
//     final spacing = size.width * 0.08;
//     final startX = size.width * 0.15;

//     final progressHeights = [0.4, 0.6, 0.8, 0.5, 0.7];
//     for (int i = 0; i < progressHeights.length; i++) {
//       final x = startX + i * (barWidth + spacing);
//       final barHeight = size.height * progressHeights[i];
//       final y = size.height * 0.7 - barHeight;

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(x, size.height * 0.3, barWidth, size.height * 0.4),
//           const Radius.circular(4),
//         ),
//         Paint()..color = color.withOpacity(0.3),
//       );

//       canvas.drawRRect(
//         RRect.fromRectAndRadius(
//           Rect.fromLTWH(x, y, barWidth, barHeight),
//           const Radius.circular(4),
//         ),
//         paint,
//       );
//     }

//     final checkCircleCenter = Offset(size.width * 0.75, size.height * 0.25);
//     final checkCircleRadius = size.width * 0.08;

//     canvas.drawCircle(checkCircleCenter, checkCircleRadius, paint);

//     final checkPath = Path();
//     final checkSize = checkCircleRadius * 0.6;
//     checkPath.moveTo(
//       checkCircleCenter.dx - checkSize * 0.3,
//       checkCircleCenter.dy,
//     );
//     checkPath.lineTo(
//       checkCircleCenter.dx - checkSize * 0.1,
//       checkCircleCenter.dy + checkSize * 0.3,
//     );
//     checkPath.lineTo(
//       checkCircleCenter.dx + checkSize * 0.4,
//       checkCircleCenter.dy - checkSize * 0.2,
//     );

//     canvas.drawPath(
//       checkPath,
//       Paint()
//         ..color = color.withOpacity(0.2)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 3
//         ..strokeCap = StrokeCap.round,
//     );

//     final arrowPath = Path();
//     arrowPath.moveTo(size.width * 0.2, size.height * 0.85);
//     arrowPath.lineTo(size.width * 0.8, size.height * 0.75);

//     canvas.drawPath(arrowPath, strokePaint);

//     final arrowHeadSize = size.width * 0.04;
//     final arrowHeadPath = Path();
//     arrowHeadPath.moveTo(
//       size.width * 0.8 - arrowHeadSize,
//       size.height * 0.75 - arrowHeadSize * 0.5,
//     );
//     arrowHeadPath.lineTo(size.width * 0.8, size.height * 0.75);
//     arrowHeadPath.lineTo(
//       size.width * 0.8 - arrowHeadSize,
//       size.height * 0.75 + arrowHeadSize * 0.5,
//     );

//     canvas.drawPath(arrowHeadPath, strokePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
