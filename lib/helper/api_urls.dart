
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
  static const String modulesService = '${baseUrl}service';
  static const String banner = '${baseUrl}banner';
  static const String provider = '${baseUrl}provider';
  static const String serviceCustomer = '${baseUrl}service-customer';
  static const String coupon = '${baseUrl}coupon';
  static const String checkout = '${baseUrl}checkout';


  static const CASHFREE_APP_ID= 'TEST10670800c5ec32bec81b65cc43c200807601';
  static const CASHFREE_SECRET_KEY= 'cfsk_ma_test_068c676f7fad1ab1ddb933fbf77c874e_a4063bc9';

  static const cashfreeUil  =  '${baseUrl}cashfree/order';
}