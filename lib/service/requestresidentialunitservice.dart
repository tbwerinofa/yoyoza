import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:yoyoza/Model/RequestResidentialUnit.dart';
import '../Model/Globals.dart';


class RequestResidentialUnitService{
  //static String requestUrl='http://hrts.us-east-1.elasticbeanstalk.com/api/requestresidentialunit/';
  static String scheme = 'http';
  static String apiHost = '13.244.198.236';
  static String requestPath = '/api/requestresidentialunit/';
  static String authorization = 'Bearer ' + Globals.token;



  Future<List<RequestResidentialUnit>> fetchEntityList(int id) async{
    print('Api residential Unit Call');
    List<RequestResidentialUnit> resultList = new List<RequestResidentialUnit>();


    var queryParameters = {
      'Id':id.toString(),
    };

    var url = new Uri(scheme: scheme,
      host: apiHost,
      path: requestPath,
      queryParameters:queryParameters
    );
    //all calls to the server are now secure so must pass the oAuth token or our call will be rejected
    print('Api before');
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: authorization},
    );

    print(response.statusCode);

    //alice.onHttpResponse(response);
    if (response.statusCode == 200) {

      if(response.headers['expires'] == '-1') {
        try {
      Iterable json = convert.jsonDecode(response.body);
       resultList = json.map((model)=> RequestResidentialUnit.fromJson(model)).toList();
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

  static Future<bool> postEntity(RequestResidentialUnit entity) async{
print('Latitude ${entity.latitude}  Longitude: ${entity.longitude}');
    var url = new Uri(scheme: scheme,
        host: apiHost,
        path: requestPath
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
    'Accpet':'application/json',
    HttpHeaders.authorizationHeader: authorization
  };
}