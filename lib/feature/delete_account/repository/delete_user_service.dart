import 'package:http/http.dart' as http;

Future<void> deleteUser(String userId) async {
  final url = Uri.parse("https://biz-booster.vercel.app/api/users/$userId");
  final response = await http.delete(url);

  if (response.statusCode != 200) {
    throw Exception("Failed to delete account");
  }
}
