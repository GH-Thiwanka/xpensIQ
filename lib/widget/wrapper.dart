import 'package:flutter/material.dart';
import 'package:xpensiq/screens/onboarding_Screen.dart';
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
    return widget.shawMainScreen
        ? const BottomNavBar()
        : const OnboardingScreen();
  }
}
