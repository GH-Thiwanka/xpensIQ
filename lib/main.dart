import 'package:flutter/material.dart';
import 'package:xpensiq/screens/splach_screen.dart';

void main() {
  runApp(const XpensIQ());
}

class XpensIQ extends StatefulWidget {
  const XpensIQ({super.key});

  @override
  State<XpensIQ> createState() => _XpensIQState();
}

class _XpensIQState extends State<XpensIQ> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplachScreen(),
    );
  }
}
