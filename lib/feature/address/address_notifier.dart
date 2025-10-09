import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressNotifier extends ChangeNotifier {
  String _confirmedAddress = '';
  double? _latitude;
  double? _longitude;

  String get confirmedAddress => _confirmedAddress;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  AddressNotifier() {
    _loadConfirmedAddress();
  }

  Future<void> _loadConfirmedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('user_city');
    final state = prefs.getString('user_state');
    _latitude = prefs.getDouble('user_lat');
    _longitude = prefs.getDouble('user_lng');

    if (city != null && state != null) {
      _confirmedAddress = '$city, $state';
    } else {
      _confirmedAddress = 'Select Address';
    }

    notifyListeners();
  }

  Future<void> setConfirmedAddress(
      String city,
      String state, {
        double? lat,
        double? lng,
      }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_city', city);
    await prefs.setString('user_state', state);

    if (lat != null && lng != null) {
      await prefs.setDouble('user_lat', lat);
      await prefs.setDouble('user_lng', lng);
      _latitude = lat;
      _longitude = lng;
    }

    _confirmedAddress = '$city, $state';
    notifyListeners();
  }
}
