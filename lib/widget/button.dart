import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class CustomButton extends StatelessWidget {
  final Color btnColor;
  final String btnName;
  const CustomButton({
    super.key,
    this.btnColor = kMainColor,
    required this.btnName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.height * 0.015,
        ),
      ),
      child: Center(
        child: Text(
          btnName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: kCardColor,
          ),
        ),
      ),
    );
  }
}
