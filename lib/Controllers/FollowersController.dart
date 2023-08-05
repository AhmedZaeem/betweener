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
