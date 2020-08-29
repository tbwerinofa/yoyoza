import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/Assessment.dart';
import '../Model/Globals.dart';


class AssessmentService{

  Future<List<Assessment>> fetchEntityList(int id) async{
    print('Api residential Unit Call');
    List<Assessment> resultList = new List<Assessment>();


    var queryParameters = {
      'Id':id.toString(),
    };

    var url = new Uri(scheme: Globals.scheme,
      host: Globals.apiHost,
      path: Globals.assessmentPath,
      queryParameters:queryParameters
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    print('Api before');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: Globals.authorization},
    );

    print(response.statusCode);

    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {

      if(response.headers['expires'] == '-1') {
        try {
      Iterable json = convert.jsonDecode(response.body);
       resultList = json.map((model)=> Assessment.fromJson(model)).toList();
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    }
    else {
      // resp.error = response.reasonPhrase;
     // return 'error';
    }

    print('Api After return');
    return resultList;
  }

  static Future<bool> postEntity(Assessment entity) async{

    var url = new Uri(scheme: Globals.scheme,
        host: Globals.apiHost,
        path: Globals.assessmentPath
    );

    var entityBody = convert.jsonEncode(entity.toMap());
    var res = await http.post(
        url,
        headers:headers,
        body:entityBody);

    print(res.body);


    return Future.value(res.statusCode == 200?true:false);
  }

  static Map<String,String> headers = {
    'Content-type':'application/json',
    'Accept':'application/json',
    HttpHeaders.authorizationHeader: Globals.authorization
  };
}