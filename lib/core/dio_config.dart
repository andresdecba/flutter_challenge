// configuracion base de dio

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioConfig {
  static final Dio dio = Dio()
    ..options.baseUrl = 'https://jsonplaceholder.typicode.com'
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 30)
    ..interceptors.add(
      PrettyDioLogger(
        request: true,
        responseBody: true,
        requestBody: true,
        error: true,
      ),
    );
}
