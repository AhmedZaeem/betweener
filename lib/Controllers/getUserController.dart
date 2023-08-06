import 'package:betweener/enums.dart';
import 'package:betweener/main.dart';
import 'package:http/http.dart' as http;

import '../Models/UserModel.dart';
import 'CachedController.dart';

Future<User?> getUserByID(int id) async {
  final token = await CachedController().getData(sharedPrefKeys.token);
  var res = await http.get(
    Uri.parse('$apiLink/users/$id'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return userModelFromJson(res.body).user;
  }
  return null;
}
