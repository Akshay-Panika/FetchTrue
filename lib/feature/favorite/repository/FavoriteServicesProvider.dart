import 'package:flutter/cupertino.dart';

class FavoriteServicesProvider extends ChangeNotifier {
  List<String> _favoriteServiceIds = [];

  List<String> get favoriteServiceIds => _favoriteServiceIds;

  void setFavoriteServices(List<String> favorites) {
    _favoriteServiceIds = favorites;
    notifyListeners();
  }

  void removeFavoriteService(String serviceId) {
    _favoriteServiceIds.remove(serviceId);
    notifyListeners();
  }

  void addFavoriteService(String serviceId) {
    if (!_favoriteServiceIds.contains(serviceId)) {
      _favoriteServiceIds.add(serviceId);
      notifyListeners();
    }
  }
}
