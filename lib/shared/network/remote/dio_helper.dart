import 'package:dio/dio.dart';

class Dio_Helper {
  static Dio dio = Dio();

  static init() async {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: 'https://student.valuxapps.com/api/',
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    dynamic query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    dynamic query,
    required dynamic data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    required String url,
    dynamic query,
    required dynamic data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.put(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String url,
    dynamic query,
    dynamic data,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      "Content-Type": "application/json",
      "lang": lang,
      "Authorization": token,
    };
    return await dio.delete(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
