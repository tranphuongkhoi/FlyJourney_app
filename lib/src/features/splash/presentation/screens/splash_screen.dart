import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  final bool isFirstLaunch;
  
  const SplashScreen({
    super.key, 
    this.onFinished,
    this.isFirstLaunch = true,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    
    // Navigate to main screen after delay
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    // Different loading times based on launch type
    final Duration loadingDuration = widget.isFirstLaunch 
        ? const Duration(milliseconds: 3000) // 3 seconds for first launch
        : const Duration(milliseconds: 1500); // 1.5 seconds for resume
    
    await Future.delayed(loadingDuration);
    
    if (mounted) {
      if (widget.onFinished != null) {
        widget.onFinished!();
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Simple airplane icon (no animation)
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    size: 60,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // App title with Hero Animation
              Center(
                child: Hero(
                  tag: 'fly_journey_logo',
                  child: Material(
                    color: Colors.transparent,
                    child: const Text(
                      'Fly Journey',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Loading indicator only (no text)
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
