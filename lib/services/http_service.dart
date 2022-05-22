// ignore_for_file: file_names, use_rethrow_when_possible
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class HttpService {
  static Dio dio = Dio();

  static Future<Response> hGet(String url) async {
    var logger = Logger();
    try {
      Response res = await dio.get(
        url,
      );

      return res;
    } catch (e) {
      logger.d(e);
      throw (e);
    }
  }
}
