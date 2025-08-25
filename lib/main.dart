import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpensiq/screens/splach_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
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
