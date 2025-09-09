import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class Profilewidgets extends StatelessWidget {
  final String title;
  final IconData icon;
  const Profilewidgets({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefultPadding * 2),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: kMainColor.withAlpha(40),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 38, color: kMainColor),
          ),
          SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: kMainTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
