import 'package:betweener/Models/Link.dart';
import 'package:betweener/Models/UserModel.dart';
import 'package:betweener/Screens/MainViews/profileView.dart';
import 'package:betweener/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> getUserByID(int id, BuildContext context) async {
  var res = await http.get(Uri.parse('$apiLink/users/$id'));
  if (res.statusCode == 200 && context.mounted) {
    User? user = userModelFromJson(res.body).user;
    List<Link>? links = linkFromJson(res.body);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const profileView()));
  }
}
