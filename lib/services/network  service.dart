import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workoutnote/utils/utils.dart';

class WebServices {
  static Map<String, String> headers = {'Accept': 'application/json; charset=UTF-8'};

  static Future<http.Response> userLogin(String email, String password) async {
    final url = Uri.https(baseUrl, login);
    final body = {'email': '$email', 'password': '$password'};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    print(response.body);
    return response;
  }

  static Future<http.Response> fetchWorkOuts(String sessionKey, int fromTimestamp,  int tillTimesatmp) async {
    final url = Uri.https(baseUrl, fetch_workouts);
    final body = {'sessionKey': '$sessionKey', 'fromTimestampMs': '$fromTimestamp', 'tillTimestampMs': tillTimesatmp};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

    return response;
  }

  static Future<http.Response> fetchExercises() async {
    final url = Uri.https(baseUrl, fetch_exercises);
    final body = {};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> fetchBodyParts() async {
    final url = Uri.https(baseUrl, fetchBody);
    final body = {};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> insertLift(String sessionKey, int timestamp, int liftMass, int exerciseId, int workoutSessioId, int repetitions,  double rm) async {
    final url = Uri.https(baseUrl, insert_lift);
    final body = {'sessionKey': sessionKey, 'timestamp': timestamp, 'lift_mass': liftMass, 'exercise_id': exerciseId, 'workout_session_id': workoutSessioId, "repetitions": repetitions, 'one_rep_max': rm };

    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> insertWorkOut(String sessionKey, String title, int timestamp, int duration) async {
    final url = Uri.https(baseUrl, insert_workout);
    final body = {'sessionKey': sessionKey, 'title': title, 'timestamp': timestamp, 'duration': duration};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> fetchSettings(String sessionKey) async {
    final url = Uri.https(baseUrl, fetch_settings);
    final body = {'sessionKey': sessionKey};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> updateSettings(String sessionKey, String name, String gender) async {
    final url = Uri.https(baseUrl, update_settings);
    final body = {'sessionKey': sessionKey, 'name': name, 'gender': gender};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> sendVerification(String email) async {
    final url = Uri.https(baseUrl, sendVerificationCode);
    final body = {'email': email};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> verifyRegister(String name, String email, String verificationCode, String password) async {
    final url = Uri.https(baseUrl, verify);
    final body = {'name': name, "email": email, "verification_code": verificationCode, "password": password};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> setFavoriteWorkOut(String sessionKey, int workoutSessionId) async {
    final url = Uri.https(baseUrl, setFavoriteWorkout);
    final body = {'sessionKey': sessionKey, 'workout_session_id': workoutSessionId};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> unsetFavoriteWorkOut(String sessionKey, int workoutSessionId) async {
    final url = Uri.https(baseUrl, unsetFavoriteWorkout);
    final body = {'sessionKey': sessionKey, 'workout_session_id': workoutSessionId};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> setMyFavoriteExercise(String sessionKey, int workoutSessionId) async {
    final url = Uri.https(baseUrl, setFavoriteExercise);
    final body = {'sessionKey': sessionKey, 'exercise_id': workoutSessionId};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> unsetMyFavoriteExercise(String sessionKey, int workoutSessionId) async {
    final url = Uri.https(baseUrl, unsetFavoriteExercise);
    final body = {'sessionKey': sessionKey, 'exercise_id': workoutSessionId};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> fetchFavoriteExercises(String sessionKey) async {
    final url = Uri.https(baseUrl, fetchFavoriteExercise);
    final body = {'sessionKey': sessionKey};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> resetPassword(String email) async {
    final url = Uri.https(baseUrl, passwordReset);
    final body = {'email': email};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> updateWorkout(String sessionKey, int id, String newTitle, int newDuration) async {
    final url = Uri.https(baseUrl, passwordReset);
    final body = {'sessionKey': sessionKey, 'workout_session_id': id, 'new_title': newTitle, "new_duration": newDuration};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> removeWorkout(String sessionKey, int id) async {
    final url = Uri.https(baseUrl, removeWorkOut);
    final body = {'sessionKey': sessionKey, 'workout_session_id': id};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> fetchFavoriteWorkoutSessions(String sessionKey) async {
    final url = Uri.https(baseUrl, fetchFavoriteWorkouts);
    final body = {'sessionKey': sessionKey};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> updateLift(String sessionKey, int  workoutSessionId, int liftId, int newExerciseId, int newLiftMass , int newRep ) async {
    final url = Uri.https(baseUrl, fetchFavoriteWorkouts);
    final body = {'sessionKey': sessionKey, 'workout_session_id':  workoutSessionId, 'lift_id': liftId, 'new_exercise_id': newExerciseId,  'new_lift_mass': newLiftMass, 'new_repetitions': newRep};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

}
