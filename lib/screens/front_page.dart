import 'package:flutter/material.dart';
import 'package:xpensiq/constants/color.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200, child: Image.asset('assets/icon.png')),
            SizedBox(height: 15),
            Text(
              'XpensIQ',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
