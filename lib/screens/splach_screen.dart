import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xpensiq/constants/color.dart';
import 'package:xpensiq/screens/onboarding_Screen.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/wrapper.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Check user status and navigate accordingly after splash duration
    _navigateAfterSplash();
  }

  _navigateAfterSplash() async {
    // Show splash for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if user has username
    bool hasUserName = await Userservice.checkUserName();

    if (!mounted) return;

    // Navigate to appropriate screen
    if (hasUserName) {
      // User exists, go to main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Wrapper(shawMainScreen: true),
        ),
      );
    } else {
      // New user, go to onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kCardColor, Color(0xFF388E3C)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: kBgMaincolor,
                    borderRadius: BorderRadius.circular(30),
                    gradient: RadialGradient(
                      colors: [kBgMaincolor, kMainColor],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kDefultPadding * 1.5),
                    child: Image.asset('assets/icon.png'),
                  ),
                ),
                const SizedBox(height: 20),
                // Optional: Add app name or loading indicator
                const Text(
                  'XpensIQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
