import 'package:dio/dio.dart';

import '../../../helper/api_client.dart';
import '../model/applied_coupon_model.dart';

class AppliedCouponRepository {
  final ApiClient _apiClient = ApiClient();

  /// Fetch coupons used by user
  Future<List<AppliedCoupon>> fetchCouponsByUser(String userId) async {
    try {
      final response = await _apiClient.get(
        'https://api.fetchtrue.com/api/coupon/used-by-user/$userId',
      );

      if (response.statusCode == 200) {
        final couponResponse = AppliedCouponResponse.fromJson(response.data);
        return couponResponse.data;
      } else {
        throw Exception('Failed to load coupons');
      }
    } catch (e) {
      throw Exception('Error fetching coupons: $e');
    }
  }
}
