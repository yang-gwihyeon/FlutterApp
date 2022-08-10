import 'dart:io';

import 'package:asl_recognition_app/asl_ML_page.dart';
import 'package:asl_recognition_app/dri_ML_page.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'cropper/ui_helper.dart'
    if (dart.library.io) 'cropper/mobile_ui_helper.dart'
    if (dart.library.html) 'cropper/web_ui_helper.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          highlightColor: Color.fromARGB(255, 75, 141, 83),
          backgroundColor: const Color(0xFFFDF5EC),
          canvasColor: Color.fromARGB(255, 241, 253, 236),
          textTheme: TextTheme(
            headline5: ThemeData.light()
                .textTheme
                .headline5!
                .copyWith(color: const Color(0xFFBC764A)),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 173, 188, 74),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Color.fromARGB(255, 74, 188, 78)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
              ),
              side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Color(0xFFBC764A))),
            ),
          )),

      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => const HomePage(),
      },
      initialRoute: '/',
    );
  }
}

class HomePage extends StatefulWidget {
  
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
  with SingleTickerProviderStateMixin{


  late TabController tcontroller;

  @override
  void initState() {

    super.initState();
    tcontroller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  TabBarView(
        controller: tcontroller,
        children: [
          driPage(),aslPage()
        ]
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 121, 199, 161),
        height: 80,
        child: TabBar(
          controller: tcontroller,
          labelColor: Colors.black87,
          indicatorColor: Colors.purple,
          tabs: const [
            Tab(
              icon: Icon(Icons.pedal_bike,
              color:  Colors.deepPurple,
              ),
              text: '따릉이 예측',
            ),
            Tab(
              icon: Icon(Icons.back_hand_sharp,
              color:  Colors.indigo,
              ),
              text: '미국식 수화',
            ),
          ],
        ),
      )
    );
  }


}