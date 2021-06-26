

import 'package:dio/dio.dart';

class ApiHelper {


  static Future<Response> makeGetRequest(url) async {
    // print("GET ==><== $url");
    return await Dio().get(url, options: Options(
      headers: {
        "x-rapidapi-key": "19098355edmshf1ffa53ca72495fp1afd58jsn3303764620a0",
        "x-rapidapi-host": "fixer-fixer-currency-v1.p.rapidapi.com",
        "useQueryString": true
      }
    )).then((value) => value);
  }


  static Future<Response> makePostRequest(url, data) async {
    return await Dio().post(url, data: FormData.fromMap(data)).then((value) => value);
  }

}