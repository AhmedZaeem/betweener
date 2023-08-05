import 'dart:convert';

import 'package:betweener/Screens/auth/Login.dart';
import 'package:betweener/enums.dart';
import 'package:betweener/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Models/Link.dart';
import 'CachedController.dart';

Future<List<Link>?> getLinks(BuildContext context) async {
  final token = await CachedController().getData(sharedPrefKeys.token);
  final response = await http.get(Uri.parse('$apiLink/links'),
      headers: {'Authorization': 'Bearer $token'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['links'] as List<dynamic>;

    return data.map((e) => Link.fromJson(e)).toList();
  }

  if (response.statusCode == 401) {
    var controller = CachedController();
    await controller.setData(sharedPrefKeys.user, null);
    await controller.setData(sharedPrefKeys.token, null);
    if (context.mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }

  return Future.error('Something wrong');
}

Future<bool> addLinks(Map<String, dynamic> body) async {
  final token = await CachedController().getData(sharedPrefKeys.token);

  final response = await http.post(
    Uri.parse('$apiLink/links'),
    body: body,
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> deleteLink(int id) async {
  final token = await CachedController().getData(sharedPrefKeys.token);
  var res = await http.delete(
    Uri.parse('$apiLink/links/${id.toString()}'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return true;
  }
  return false;
}

Future<bool> editLink(Map<String, dynamic> body, int linkID) async {
  final token = await CachedController().getData(sharedPrefKeys.token);

  var res = await http.put(
    Uri.parse('$apiLink/links/$linkID'),
    body: body,
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return true;
  }
  return false;
}
