import 'package:url_launcher/url_launcher.dart';

void CustomUrlLaunch(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print('Could not launch $url');
  }
}

