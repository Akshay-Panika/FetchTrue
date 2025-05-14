
class ApiUrls{

  static const String baseUrl = 'https://biz-booster.vercel.app/api/';

  /// Auth api
  static const String signUp = '${baseUrl}auth/register';
  static const String signIn = '${baseUrl}auth/login';
  static const String verifyOtp = '${baseUrl}auth/verify-otp';


  /// Module Api
  static const String modules = '${baseUrl}modules';
  static const String modulesCategory = '${baseUrl}category';
  static const String modulesSubcategory = '${baseUrl}subcategory';

}