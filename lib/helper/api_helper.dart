import 'package:bizbooster2x/helper/api_urls.dart';
import 'package:bizbooster2x/model/module_category_model.dart';
import 'package:bizbooster2x/model/module_subcategory_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/widgets/custom_snackbar.dart';
import '../model/module_model.dart';
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


/// Module
class ModuleService {
  final Dio _dio = Dio();

  Future<List<ModuleModel>> fetchModules() async {
    try {
      final response = await _dio.get(ApiUrls.modules);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ModuleModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load modules: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}

class CategoryService {
  final Dio _dio = Dio();

  Future<List<ModuleCategoryModel>> fetchCategories() async {
    try {
      final response = await _dio.get(ApiUrls.modulesCategory);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((item) => ModuleCategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}

class SubCategoryService {
  final Dio _dio = Dio();

  Future<List<ModuleSubCategoryModel>> fetchSubCategories() async {
    try {
      final response = await _dio.get(ApiUrls.modulesSubcategory);

      if (response.statusCode == 200 && response.data['success'] == true) {
        List data = response.data['data'];
        return data.map((json) => ModuleSubCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sub-categories');
      }
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }
}
