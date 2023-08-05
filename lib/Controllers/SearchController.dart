import 'dart:convert';

import 'package:betweener/enums.dart';
import 'package:betweener/main.dart';
import 'package:http/http.dart' as http;

import '../Models/UserModel.dart';
import 'CachedController.dart';

Future<List<User>> getSearchData(String search) async {
  final token = CachedController().getData(sharedPrefKeys.token);
  final res = await http.post(
    Uri.parse('$apiLink/search'),
    body: {'name': search},
    headers: {'Authorization': 'Bearer $token'},
  );

  List<User> userList = [];
  var myUser =
      userModelFromJson(await CachedController().getData(sharedPrefKeys.user));
  for (var user in jsonDecode(res.body)['user']) {
    User newUser = User.fromJson(user);
    if (newUser.id != myUser.user!.id) {
      userList.add(newUser);
    }
  }

  return userList;
}
