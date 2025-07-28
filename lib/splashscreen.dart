import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:notex/main.dart';
import 'package:notex/username_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    checkuser();
  }

  void checkuser() async {
    await Future.delayed(Duration(seconds: 4));

    var prefs = await SharedPreferences.getInstance();
    String? USER_NAME = prefs.getString('User');
    if (USER_NAME != null && USER_NAME.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>MyHomePage())
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UsernameInput()),
      );
    }
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromARGB(255, 112, 149, 167),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            SizedBox(height: 50),
            Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),

                child: 
                 AnimatedTextKit(
                   animatedTexts: [
                      ScaleAnimatedText(
                       'NoteX',
                       duration: Duration(milliseconds: 7000),
                     ),
                   ],
                   totalRepeatCount: 1,
                   isRepeatingAnimation: false,
                   repeatForever: false,
                 ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(
                        'Powered by',
                        duration: Duration(milliseconds: 7000),
                      ),
                    ],
                  ),
                ),

                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),

                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'NAJAF_DEVS',
                        speed: Duration(milliseconds: 300),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: Duration(milliseconds: 150),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
