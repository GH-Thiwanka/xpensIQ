import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpensiq/screens/splach_screen.dart';
import 'package:xpensiq/service/userService.dart';
import 'package:xpensiq/widget/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return FutureBuilder(
      future: Userservice.checkUserName(),
      builder: (context, snapshot) {
        //if the snapshot is still waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          bool hasUserName = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Inter'),
            //darkTheme: ThemeData.dark(),
            home: Wrapper(shawMainScreen: hasUserName),
          );
        }
      },
    );
  }
}
