//api  urls
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "workoutnote.com";
const String login = "api/login/";
const String fetch_workouts = "api/fetch_workouts/";
const String fetch_exercises = "api/fetch_exercises/";
const String insert_workout = "/api/insert_workout";
const String insert_lift = "/api/insert_lift";
const String fetch_settings = "/api/fetch_settings";
const String update_settings = "/api/update_settings";
const String sendVerificationCode = "/api/send_verification_code";
const String verify = "/api/verify_register";
const String fetchBody = "/api/fetch_body_parts";

//network  state codes
const int LOADING = 0;
const int TIMEOUT_EXCEPTION = 1;
const int SOCKET_EXCEPTION = 2;
const int MISC_EXCEPTION = 3;
const int SUCCESS = 4;

//util  methods
SharedPreferences? userPreferences;
Future<void> initPreferences() async {
  userPreferences = await SharedPreferences.getInstance();

}

String toDate(int timestamp) {

  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat('yyyy.MM.dd').format(date);
   print(formattedDate);
  return formattedDate;
}



void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0);
}

class Language {
  String? name;
  int? index;

  Language(this.name, this.index);
}

