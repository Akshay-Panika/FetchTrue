import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:dio/dio.dart';

/// Base Api Helper
class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiUrls.baseUrl, // use common baseUrl
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));
  // ..interceptors.add(LogInterceptor(
  // request: true,
  // requestHeader: true,
  // requestBody: true,
  // responseHeader: false,
  // responseBody: true,
  // error: true,
  // compact: true,
  // ));
}




