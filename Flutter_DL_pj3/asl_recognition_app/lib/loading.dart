
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:asl_recognition_app/listViewPage.dart';
import 'package:asl_recognition_app/main.dart';


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// late Map busers = {"buid": 'aaa'}; // ????

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Together!',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AnimatedSplashScreen(
          // 스플래쉬
          splash: 'images/signlanguage.png',
          splashIconSize: 200,
          duration: 1000,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Color(0xffFFF8DC),
          nextScreen: const HomePage()),
      routes: {
// 로그인 화면
          '/1st' : (context) => const HomePage(),
        '/2nd' : (context) => ListviewPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
