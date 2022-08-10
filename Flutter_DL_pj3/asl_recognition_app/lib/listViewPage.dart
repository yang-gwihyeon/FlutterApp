import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';


List imageName = ["images/001.jpg","images/002.jpg","images/003.jpg","images/004.jpg","images/005.jpg","images/006.jpg","images/007.jpg","images/008.jpg","images/009.jpg","images/010.jpg"];
class ListviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group List View Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('수화 정보'),
          backgroundColor:  Color.fromARGB(255, 138, 209, 58),
        ),
        body: GroupListView(
          sectionsCount: 1,
          countOfItemInSection: (int section) {
            return 10;
          },
          itemBuilder: _itemBuilder,
          groupHeaderBuilder: (BuildContext context, int section) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                children: [
                   SizedBox(height: 15),
                  Text(
                    "숫자 0~10 수화",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
        ),
          floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pop();
    
        },
        label: const Text('Back'),
        icon: const Icon(Icons.arrow_back),
        backgroundColor: Color.fromARGB(255, 74, 188, 142),
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
                Image.asset(imageName[index.index],width: 310, height: 200,)
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