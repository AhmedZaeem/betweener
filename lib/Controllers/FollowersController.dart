import 'package:betweener/enums.dart';
import 'package:betweener/main.dart';
import 'package:http/http.dart' as http;

import '../Models/Followers.dart';
import 'CachedController.dart';

Future<Followers> getFollowers() async {
  final token = CachedController().getData(sharedPrefKeys.token);
  final res = await http.get(
    Uri.parse('$apiLink/follow'),
    headers: {'Authorization': 'Bearer $token'},
  );
  return followersFromJson(res.body);
}

Future<bool> followSomeone(int followeeId) async {
  final token = CachedController().getData(sharedPrefKeys.token);
  final res = await http.post(
    Uri.parse('$apiLink/follow'),
    body: {'followee_id': '$followeeId'},
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return true;
  }
  return false;
}
