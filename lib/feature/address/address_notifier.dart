import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressNotifier extends ChangeNotifier {
  String _confirmedAddress = '';

  String get confirmedAddress => _confirmedAddress;

  AddressNotifier() {
    _loadConfirmedAddress();
  }

  Future<void> _loadConfirmedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('user_city');
    final state = prefs.getString('user_state');

    if (city != null && state != null) {
      _confirmedAddress = '$city, $state';
    } else {
      _confirmedAddress = 'Select Address';
    }
    notifyListeners();
  }

  Future<void> setConfirmedAddress(String city, String state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_city', city);
    await prefs.setString('user_state', state);

    _confirmedAddress = '$city, $state';
    notifyListeners();
  }
}