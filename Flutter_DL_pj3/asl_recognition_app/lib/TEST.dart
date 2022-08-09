import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';


void main() => runApp(MyApp());

Map<String, List> _elements = {
  'Team A': ['Klay Lewis', 'Ehsan Woodard', 'River Bains'],
  'Team B': ['Toyah Downs', 'Tyla Kane'],
  'Team C': ['Marcus Romero', 'Farrah Parkes', 'Fay Lawson', 'Asif Mckay'],
  'Team D': [
    'Casey Zuniga',
    'Ayisha Burn',
    'Josie Hayden',
    'Kenan Walls',
    'Mario Powers'
  ],
  'Team Q': ['Toyah Downs', 'Tyla Kane', 'Toyah Downs'],
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('수화 사진 페이지'),
        ),
        body: GroupListView(
          sectionsCount: 1,
          countOfItemInSection: (int section) {
            return 11;
          },
          itemBuilder: _itemBuilder,
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Text(
                "             숫자 0~10 수화",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    // String user = _elements.values.toList()[index.section][index.index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 8,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
  
            title: Row(
              children: [
                Image.asset('images/01.png',width: 310, height: 200,)
              ],
            ),
     
          ),
        ),
      ),
    );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }


}