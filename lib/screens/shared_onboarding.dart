import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class SharedOnboarding extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  const SharedOnboarding({
    super.key,
    required this.title,
    required this.image,
    required this.description,
  });

  @override
  State<SharedOnboarding> createState() => _SharedOnboardingState();
}

class _SharedOnboardingState extends State<SharedOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(widget.image, width: 300, fit: BoxFit.cover),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 32,
              color: kMainTextColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            widget.description,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
