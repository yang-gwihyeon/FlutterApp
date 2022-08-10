import 'package:asl_recognition_app/listViewPage.dart';
import 'package:asl_recognition_app/main.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     routes: {
       
       '/1st' : (context) => const HomePage(),
        '/2nd' : (context) => ListviewPage(),
     },
     initialRoute: '/1st',
    );
  }
}