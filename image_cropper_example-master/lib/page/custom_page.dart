import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_cropper_example/utils.dart';
import 'package:image_cropper_example/widget/floating_button.dart';
import 'package:image_cropper_example/widget/floating_button02.dart';
import 'package:image_cropper_example/widget/image_list_widget.dart';

class CustomPage extends StatefulWidget {
  final bool isGallery;

  const CustomPage({
    Key key,
    @required this.isGallery,
  }) : super(key: key);

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  List<File> imageFiles = [];
      String result = "all";

   String imageName;
   
    String base64Image;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ImageListWidget(imageFiles: imageFiles),
        floatingActionButton: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: FloatingButtonWidget(onClicked: onClickedButton),
            ),
            FloatingButtonWidget2(onClicked: printButton),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        
        
      );

  Future onClickedButton() async {
     imageFiles = [];
    final file = await Utils.pickMedia(
      isGallery: widget.isGallery,
      cropImage: cropPredefinedImage,
    );

    if (file == null) return;
    setState(() => imageFiles.add(file));

    File imageFile = imageFiles[0];
    List<int> imageBytes = imageFile.readAsBytesSync();
    base64Image = base64Encode(imageBytes);
     print(base64Image);
  
  }

    Future printButton() async {
    print(base64Image);
    
    getJSONData(base64Image);
    
  
  }


    Future removeButton() async {
    
    setState(() {
      
    });
  
  
  }

  static Future<File> cropCustomImage(File imageFile) async =>
      await ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
        sourcePath: imageFile.path,
        androidUiSettings: androidUiSettings(),
        iosUiSettings: iosUiSettings(),
      );

      

  static IOSUiSettings iosUiSettings() => IOSUiSettings(
        aspectRatioLockEnabled: false,
      );

  static AndroidUiSettings androidUiSettings() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false,
      );


    void getJSONData(String imageFile) async {
    var url = Uri.parse(
        'http://192.168.150.83:5000/iris?imageFile=$imageFile');
    var response = await http.get(url);
    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      result = dataConvertedJSON['result'];
      // print(result);
    });

    _showDialog(context, result);
    }
//}

  void _showDialog(BuildContext context, String result) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("코드 결과"),
            content: Text("$result"),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  // // 화면 정리
                  // sepalLengthController.text = "";
                  // sepalWidthController.text = "";
                  // petalLengthController.text = "";
                  // petalWidthController.text = "";
                  setState(() {
                    imageName = result;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
        
  }

  Future<File> cropPredefinedImage(File imageFile) async =>
      await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
        ],
        androidUiSettings: androidUiSettingsLocked(),
        iosUiSettings: iosUiSettingsLocked(),
      );

  IOSUiSettings iosUiSettingsLocked() => IOSUiSettings(
        aspectRatioLockEnabled: false,
        resetAspectRatioEnabled: false,
      );

  AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      );
}
