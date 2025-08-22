
class ApiUrls{

  static const String baseUrl = 'https://biz-booster.vercel.app/api/';

  /// Auth api
  static const String user = '${baseUrl}users';
  static const String userUpdateInfo = '${baseUrl}users/update-info';
  static const String userUpdateProfile = '${baseUrl}users/update-profile-photo';
  static const String signUp = '${baseUrl}auth/register';
  static const String signIn = '${baseUrl}auth/login';
  static const String verifyOtp = '${baseUrl}auth/verify-otp';


  /// Module Api
  static const String modules = '${baseUrl}modules';
  static const String modulesCategory = '${baseUrl}category';
  static const String modulesSubcategory = '${baseUrl}subcategory';
  static const String modulesService = '${baseUrl}service';
  static const String banner = '${baseUrl}banner';
  static const String provider = '${baseUrl}provider';
  static const String providerReview = '${baseUrl}provider/review';
  static const String serviceCustomer = '${baseUrl}service-customer';
  static const String coupon = '${baseUrl}coupon';
  static const String checkout = '${baseUrl}checkout';
  static const String leadStatus = '${baseUrl}leads';


  static const Client_id= 'TEST107274954a9cf3c92a3b5a1a511359472701';
  static const Client_secret= 'cfsk_ma_test_dc62307065968e39980c69ffe07fa7dd_2f0a9615';

  static const cashfreeUrl  =  '${baseUrl}cashfree/order';
}