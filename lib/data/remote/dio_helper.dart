import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.aladhan.com'));
  }

  static Future<List> getData({
    required double latitude, required double longitude, int method = 2, required int month, required int year
  }) async {
    Response response= await dio!.get(
        '/v1/calendar?latitude=$latitude&longitude=$longitude&method=2&month=$month&year=$year'
        );
    return response.data['data'];
  }
}