import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:yoyoza/Model/Globals.dart';
import 'package:yoyoza/Model/UserResponse.dart';
import 'package:async/async.dart';

class ImageService{
  bool success;
  String message;
  bool isUploaded;
  static String scheme = 'http';
  static String apiHost = '13.244.198.236';
  static String requestPath = '/api/document/';
  static String authorization = 'Bearer ' + Globals.token;


  Future call(String url,File _image)async {
try{
  print('start upload');
  UserResponse resp = new UserResponse();

    var applicableUrl = new Uri(scheme: scheme,
        host: apiHost,
        path: requestPath
    );


  var queryParameters = {
    'RequestID':'800',
  };




    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    final int length = await _image.length();
    print('length ${length}');
    final request = new http.MultipartRequest('POST', applicableUrl)
    ..files.add(
      new http.MultipartFile('UploadedImage', stream, length,filename:'name')
    );
    
    request.headers.addAll(headers);
    request.fields.addAll(queryParameters);

    print(request);
    http.Response response = await http.Response.fromStream(await request.send());

    final json = jsonDecode(response.body);
    //this call will fail if the security stamp for user is null

    resp.error = response.statusCode.toString() + ' ' + response.body;
    resp.description = json['error_description'] as String;

    print('Error: ${resp.error}');
    print('Description: ${resp.description}');


}catch(e){

  print(e);
  throw('Error uploading photo ${e}');
}
  }

  Future<void> call_delta(String url,File image) async{
    try{
      print('reload upload service');
      //var applicableUrl = '18.208.55.195/api/document/';
      UserResponse resp = new UserResponse();
      var applicableUrl = new Uri(scheme: scheme,
          host: apiHost,
          path: requestPath
      );
/*
      var response = await http.post(
          applicableUrl,
          body:image.readAsBytesSync(),
          headers: headers);*/

      List<MultipartFile> fileList = List();
      fileList.add(MultipartFile.fromBytes(
          'documents', await image.readAsBytesSync()));

      var request = http.MultipartRequest("POST", applicableUrl);
      request.headers.addAll(headers);
      request.files.addAll(fileList);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("responseBody " + responseString);
/*
      print(response.statusCode);
      print('upload complete');

      if(response.statusCode ==200)
      {
        isUploaded =true;
      }

      final json = jsonDecode(response.body);
      //this call will fail if the security stamp for user is null

      resp.error = response.statusCode.toString() + ' ' + response.body;
      resp.description = json['error_description'] as String;

      print('Error: ${resp.error}');
      print('Description: ${resp.description}');

 */
    }catch(e){

      print(e);
      throw('Error uploading photo ${e}');
    }
  }



  Future<void> call_Init(String url,File image) async{
    try{
  print('upload service');
      //var applicableUrl = '18.208.55.195/api/document/';
  UserResponse resp = new UserResponse();
  var applicableUrl = new Uri(scheme: scheme,
      host: apiHost,
      path: requestPath
  );

      var response = await http.post(
          applicableUrl,
          body:image.readAsBytesSync(),
      headers: headers);

  print(response.statusCode);
  print('upload complete');

      if(response.statusCode ==200)
        {
          isUploaded =true;
        }

  final json = jsonDecode(response.body);
  //this call will fail if the security stamp for user is null

  resp.error = response.statusCode.toString() + ' ' + response.body;
  resp.description = json['error_description'] as String;

  print('Error: ${resp.error}');
  print('Description: ${resp.description}');
    }catch(e){

      print(e);
      throw('Error uploading photo ${e}');
    }
  }

  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accept':'application/json',
    HttpHeaders.authorizationHeader: authorization
  };
}