import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_api_structure/Models/models.dart';
import 'package:getx_api_structure/Utils/api_endpoints.dart';
import 'package:getx_api_structure/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Controller extends GetxController {
  var photoList = <User>[].obs;
  var userdata = [];
  var isLoading = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // var resdata;
  var resdata = [];
  var globalApi = "https://jsonplaceholder.typicode.com/photos";
  @override
  void onInit() {
    super.onInit();
    fetchData(globalApi, "");
  }

  Future<void> fetchData(globalApi, apiPath) async {
    var response = await http.get(Uri.parse('$globalApi/$apiPath'));
    if (response.statusCode == 200) {
      // print(response.body);
      // User _albumModel = User.fromJson(jsonDecode(response.body));
      resdata = jsonDecode(response.body);
      // resdata.add(jsonDecode(response.body));

      // userdata = [resdata.runtimeType];
      print(resdata);
      // for (var i = 0; i < resdata.length; i++) {
      //   print(resdata[i]["albumId"]);
      //   photoList.add(
      //     User(
      //       title: resdata[i]["title"],
      //       url: resdata[i]["url"],
      //       thumbnailUrl: resdata[i]["thumbnailUrl"],
      //       id: resdata[i]["id"],
      //       albumId: resdata[i]["albumId"],
      //     ),
      //   );
      // }

      isLoading.value = false;
      update();
    } else {
      Get.snackbar('Error Loading data!',
          'Sever responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  }

  Future<void> loginWithEmail() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          var token = json['data']['Token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);

          emailController.clear();
          passwordController.clear();
          Get.off(Home());
        } else if (json['code'] == 1) {
          throw jsonDecode(response.body)['message'];
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }

  Future<void> registerWithEmail() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        'name': nameController.text,
        'email': emailController.text.trim(),
        'password': passwordController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['code'] == 0) {
          var token = json['data']['Token'];
          print(token);
          final SharedPreferences? prefs = await _prefs;

          await prefs?.setString('token', token);
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          Get.off(Home());
        } else {
          throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
        }
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: Text('Error'),
              contentPadding: EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}
