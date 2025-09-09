
class ApiUrls{

  static const String baseUrl = 'https://api.fetchtrue.com/api/';

  /// Auth api
  static const String user = '${baseUrl}users';
  static const String userUpdateInfo = '${baseUrl}users/update-info';
  static const String userUpdateProfile = '${baseUrl}users/update-profile-photo';
  static const String signUp = '${baseUrl}auth/register';
  static const String signIn = '${baseUrl}auth/login';
  static const String verifyOtp = '${baseUrl}auth/verify-otp';
  static const String forgotPassword = '${baseUrl}auth/forgot-password';


  /// Module Api
  static const String packages = '${baseUrl}packages';
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
  static const String leads = '${baseUrl}checkout/lead-by-user';
  static const String leadStatus = '${baseUrl}leads';
  static const String offer = '${baseUrl}offer';
  static const String ads = '${baseUrl}ads';
  static const String advisor = '${baseUrl}advisor';
  static const String understandingFetchTrue = '${baseUrl}academy/understandingfetchtrue';

  static const String myTeam = '${baseUrl}team-build/my-team';
  static const String upcomingLeadCommission = '${baseUrl}upcoming-lead-commission/find-by-checkoutId';


  static const Client_id= 'TEST107274954a9cf3c92a3b5a1a511359472701';
  static const Client_secret= 'cfsk_ma_test_dc62307065968e39980c69ffe07fa7dd_2f0a9615';

  static const cashfreeUrl  =  '${baseUrl}cashfree/order';
}