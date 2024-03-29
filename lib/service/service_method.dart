import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import '../config/service_url.dart';

Future getHomePageContent() async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var formData = {
      'lon': '115.02932',
      'lat': '35.76189'
    };
    response = await dio.post(servicePath['homePageContent'], data: formData);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常------------------------------');
    }
  } catch(e) {
    return print('错误:$e------------------------');
  }
}

Future request(url, {data}) async {
  try {
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if(data == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: data);
    }
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口异常------------------------------');
    }
  } catch(e) {
    return print('错误:$e------------------------');
  }
}