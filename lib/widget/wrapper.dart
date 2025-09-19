import 'package:flutter/material.dart';
import 'package:xpensiq/screens/onboarding_Screen.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/bottumNavBar.dart';

class Wrapper extends StatefulWidget {
  final bool shawMainScreen;
  const Wrapper({super.key, required this.shawMainScreen});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    if (widget.shawMainScreen) {
      // Get current user ID
      String? userId = Userservice.getCurrentUserId();

      // If no user is logged in, show onboarding screen
      if (userId == null) {
        return const OnboardingScreen();
      }

      // Return BottomNavBar with userId
      return BottomNavBar(userId: userId);
    } else {
      return const OnboardingScreen();
    }
  }
}
