import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/Request.dart';
import '../Model/Globals.dart';


class RequestService{

  static String scheme = 'http';
  static String apiHost = '13.244.198.236';
  static String requestPath = '/api/request/';
  static String authorization = 'Bearer ' + Globals.token;

  Future<List<Request>> fetchEntityList() async{
    print('Api Call');
    List<Request> resultList = new List<Request>();

    var url = new Uri(scheme: scheme,
      host: apiHost,
      path: requestPath,
    );
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: authorization},
    );

    print(response.statusCode);
    print(response.headers);
    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {
        try {
          Iterable json = convert.jsonDecode(response.body);
          resultList = json.map((model) => Request.fromObject(model)).toList();
        } catch (e) {
          return null;
       }
    }
    return resultList;
  }

  static Future<bool> postEntity(Request entity) async{

    var url = new Uri(scheme: scheme,
        host: apiHost,
        path: requestPath
    );

    var entityBody = convert.jsonEncode(entity.toMap());
    var res = await http.post(
        url,
        headers:headers,
        body:entityBody);
    return Future.value(res.statusCode == 200?true:false);
  }

  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accpet':'application/json',
    HttpHeaders.authorizationHeader: authorization
  };
}