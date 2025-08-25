import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class Txtfield extends StatelessWidget {
  final String hintText;
  final bool isSecure;
  final TextEditingController? controll;
  const Txtfield({
    super.key,
    required this.hintText,
    this.isSecure = false,
    this.controll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.065,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: kSecondaryTextColor.withAlpha(100)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kDefultPadding * 1.7),
        child: TextField(
          controller: controll,

          obscureText: isSecure,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: kBorDivColor),
          ),
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
