import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:bizbooster2x/feature/home/model/banner_model.dart';
import 'package:bizbooster2x/feature/category/model/module_subcategory_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/widgets/custom_snackbar.dart';
import '../feature/home/model/module_model.dart';
import '../model/sign_up_model.dart';


/// Auth

Future<void> registerUser(BuildContext context,UserRegistrationModel user) async {
  final dio = Dio();

  try {
    final response = await dio.post(ApiUrls.signUp,
      data: user.toJson(),
      // options: Options(
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      // ),
    );

    if (response.statusCode == 200) {
      showCustomSnackBar(context,'Registration successful');
      print(response.data);
    } else {
      showCustomSnackBar(context,'Registration failed');
      print(response.data);
    }
  } on DioException catch (e) {
    if (e.response != null) {
      showCustomSnackBar(context,'Error Response: ${e.response?.data}');
    } else {
      showCustomSnackBar(context,'Dio Error: ${e.message}');
    }
  } catch (e) {
    print('Unknown Error: $e');
  }
}



