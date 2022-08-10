import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class driPage extends StatefulWidget {
  const driPage({Key? key}) : super(key: key);

  @override
  State<driPage> createState() => _driPageState();
}

class _driPageState extends State<driPage> {
  DateTime today = DateTime.now();
  final TextEditingController tec1 = TextEditingController();
  final TextEditingController tec2 = TextEditingController();
  final TextEditingController tec3 = TextEditingController();
  late String? selectedValue;
  List<String> time = [];
  
  @override
  void initState() {
    for (int i=1; i <=48 ; i++){
      time.add(today.add(Duration(hours: i)).toString().substring(0,13)+ ":00");
    }
    selectedValue = time[0];

    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('따릉이 수요 예측')) ,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("지금은 "+today.toString().substring(0,16) + " 입니다"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("현재 시간 기준 2일 후까지의 수요 예측이 가능합니다."),
            ),

            DropdownButton<String>(
              value: selectedValue,
              items: time
                  .map(
                    (String item) => DropdownMenuItem<String>(
                      child: Text(item),
                      value: item,
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),

            ElevatedButton(
              onPressed: () {
                  predict();
              }, 
              child: Text('예측하기')
            ),            
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context, var result) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("따릉이 수요예측"),
            content: Text("이 시간대에 예측된 따릉이 수요는 $result 입니다."),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  predict() async{

    var url = Uri.parse("http://127.0.0.1:5000/dri?date=" + selectedValue! + "&today="+ today.toString().substring(0,14)+"00");
    var response = await http.get(url);
    var jsondata = json.decode(utf8.decode(response.bodyBytes));

    var result = jsondata['result'];

    _showDialog(context, result);

  }


}