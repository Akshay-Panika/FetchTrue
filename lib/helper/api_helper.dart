import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:bizbooster2x/feature/banner/model/banner_model.dart';
import 'package:bizbooster2x/feature/category/model/module_subcategory_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/widgets/custom_snackbar.dart';
import '../feature/home/model/module_model.dart';
import '../model/sign_up_model.dart';


/// Base Api Helper

class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiUrls.baseUrl, // use common baseUrl
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
    },
  ));
    // ..interceptors.add(LogInterceptor(
    //   responseBody: true,
    //   requestBody: true,
    // ));
}




