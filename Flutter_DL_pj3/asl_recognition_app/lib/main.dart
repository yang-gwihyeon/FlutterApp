import 'dart:io';

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

void main() {
  runApp(const MyApp());
}

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
            backgroundColor: Color.fromARGB(255, 74, 188, 142),
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
      home: const HomePage(title: 'Sign Language DeepLear'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  
  const HomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  bool isGallery = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Expanded(child: Center(child: Column(
                    mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Padding(
                 padding: const EdgeInsets.all(0.0),
                 child: SizedBox(
                  height: 50,
                  width: 168,
                  
                   child: ElevatedButton(
                         child: const Text('How to Use',
                         style: TextStyle(fontSize: 22),),
                         onPressed: () {
                           showModalBottomSheet<void>(
                             context: context,
                             builder: (BuildContext context) {
                               return Container(
                    height: 350,
                    color: Color.fromARGB(255, 224, 223, 212),
                    child: Center(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                  
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 2),
                                    Column(
                                      children: [
                                        Image.asset('images/0.jpeg',width: 180, height: 200,),
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text("1. 사용법"),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Image.asset('images/0.jpeg',width: 180, height: 200,),
                                         Padding(
                                           padding: const EdgeInsets.all(15.0),
                                           child: Text("2. 사용법"),
                                         )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
        
            ]),
                    ),
                               );
                             },
                           );
                         },
                       ),
                 ),
               ),
               
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _body(),
                
              ),
            ],
          ))),
        ],
      ),
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        if (_croppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                _cropImage();
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          )
        else
          FloatingActionButton(
              onPressed: () {
                onUploadImage();
              },
              backgroundColor: const Color(0xFFBC764A),
              // tooltip: 'Crop',
              child: const Icon(Icons.send),
          )
        

      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                        color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color:
                                            Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _uploadImage();
                        },
                        child: const Text('Gallery'),
                      ),
                    ),
                      ElevatedButton(
                      onPressed: () {
                        _uploadImageCamera();
                      },
                      child: const Text('Camera'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
   
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

    Future<void> _uploadImageCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
   
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }


  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }


  _showDialog(BuildContext context, String result) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Face Recognition"),
            content: Text("상기 얼굴의 이름은 $result 입니다."),
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

  onUploadImage() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse("http://127.0.0.1:5000/uploader"));
    
    File? selectedImage = File(_croppedFile!.path);
    int result = -1;
    // multipart request
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );

    request.headers.addAll(headers);
    var resp = await request.send();
    
    http.Response response = await http.Response.fromStream(resp);

    setState(() {
      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        result = dataConvertedJSON['result'];
      });
      _showDialog(context, result.toString());
    });




  }

}