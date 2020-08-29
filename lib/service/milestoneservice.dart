import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/Milestone.dart';
import '../Model/Globals.dart';


class MilestoneService{

  static String scheme = 'http';
  static String apiHost = '13.244.198.236';
  static String requestPath = '/api/milestone/';
  static String authorization = 'Bearer ' + Globals.token;

  Future<List<Milestone>> fetchEntityList() async{
    print('Api Call');
    List<Milestone> resultList = new List<Milestone>();

    var url = new Uri(scheme: scheme,
      host: apiHost,
      path: requestPath,
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    print('Api before milestone Url');
    print(url);
    print('AUth - ${authorization}');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: authorization},
    );

    print(response.statusCode);

    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      print('In business');
      print(json);
      resultList = json.map((model)=> Milestone.fromJson(model)).toList();
      print('finished');
    }
    else {
      // resp.error = response.reasonPhrase;
     // return 'error';
    }

    print('Api After return');
    return resultList;
  }

  static Future<bool> postEntity(Milestone entity) async{

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