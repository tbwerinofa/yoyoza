import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:yoyoza/Model/Globals.dart';

class ImagePickerUI extends StatefulWidget {
  ImagePickerUI({Key key}): super(key:key);
  @override
  _ImagePickerUIState createState() => _ImagePickerUIState();
}

class _ImagePickerUIState extends State<ImagePickerUI> {
  File _image;

  final String AspEndPoint ='http://hrts.us-east-1.elasticbeanstalk.com/api/document/';
  static String scheme = 'http';
  static String apiHost = '18.208.55.195';
  static String requestPath = '/api/document/';
  static String authorization = 'Bearer ' + Globals.token;
  bool showButton = false;

  //get an image from the gallery
  Future getImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null)return;

    setState(() {
      _image =image; //show the selected image and the send button
      showButton =true;
    });
  }

  //A multipart/form-data request.Such a request has both strin gfields which function as normal fields
  //and stream binary files

  Future sendImagetoServer()async{

    print('upload');
    var applicableUrl = new Uri(scheme: scheme,
        host: apiHost,
        path: requestPath
    );

    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));

    final int length = await _image.length();
    String fileName = _image.path.split("/").last;

    var queryParameters = {
      'Test':'700',
      'RequestID':'214'
    };



    // Response response = request.send();
    final request = new http.MultipartRequest(
        'POST', applicableUrl
    )
      ..fields.addAll(queryParameters)
     ..files.add(
          new http.MultipartFile('UploadedImage', stream, length, filename: fileName)
      );


    request.headers.addAll(headers);
    //request.fields.addAll(queryParameters);

    print(request.headers);
    print(request.fields);
    print('request--data');
    print(request.files);

    http.Response response = await http.Response.fromStream(await request.send());
    final json = jsonDecode(response.body);
    var error = response.statusCode.toString() + ' ' + response.body;
    var description = json['error_description'] as String;

    print('Error: ${error}');
    print('Description: ${description}');

    setState(() {
      showButton = false;
    });
  }

  static Map<String,String> headers = {
    'Content-type':'text/plain; charset=utf-8',
    //'Accept':'application/json',
    //"Content-Disposition": "form-data; RequestID=213",
    HttpHeaders.authorizationHeader: authorization
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body:Column(
        children: <Widget>[
          Container(
            height: 300,
            child: _image == null?Text('No Image Selected') :Image.file(_image),
          ),
          Row(
            children: <Widget>[
              new FloatingActionButton(
                  onPressed: getImage,
              tooltip: 'Pick Image',
              child:Icon(Icons.add_a_photo),
              ),
              showButton == true?
                  new FloatingActionButton(
                      onPressed: sendImagetoServer,
                    tooltip: 'Pick Image',
                    child:Icon(Icons.email)
                  )
                  :Container()
            ],
          )
        ],
      )
    );
  }
}
