
abstract class BannerEvent {}
class FetchBanners extends BannerEvent {
  final String? page; 
  FetchBanners({this.page});
}