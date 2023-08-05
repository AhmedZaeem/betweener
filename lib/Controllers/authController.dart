import 'dart:convert';

import 'package:betweener/Models/UserModel.dart';
import 'package:betweener/main.dart';
import 'package:http/http.dart' as http;

Future<UserModel?> login(Map<String, dynamic> body) async {
  final res = await http.post(
    Uri.parse('$apiLink/login'),
    body: body,
  );
  if (res.statusCode == 200) {
    return userModelFromJson(res.body);
  } else {
    return null;
  }
}

Future<UserModel?> register(Map<String, dynamic> body) async {
  final res = await http.post(
    Uri.parse('$apiLink/register'),
    body: body,
  );
  if (jsonDecode(res.body)['message'] == 'user created successfully') {
    return userModelFromJson(res.body);
  } else {
    return null;
  }
}
