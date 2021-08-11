import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/body%20%20parts%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class SearchDialogProvider extends ChangeNotifier {
  //vars
  List<Exercise> favoriteExercises = [];
  List<Exercise> exercises = [];
  List<BodyPart> myBodyParts = [];
  List<Exercise> exercisesByBodyParts = [];
  List<Exercise> searchExercises = [];
  int responseCode = LOADING;
  bool requestDone = false;

  bool showFavorite = false;
  String activeBodyPart = "";

  //api calls
  Future<void> fetchFavoriteExercises(String sessionKey) async {
    try {
      print("hdvuergvuierguqryuo");
      print(sessionKey);
      var response = await WebServices.fetchFavoriteExercises(sessionKey);


      print("hhhhhhhhhhhhhh: ${jsonDecode(utf8.decode(response.bodyBytes))}");
      if (response.statusCode == 200) {
        var workoutsResponse = ExercisesResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          favoriteExercises.addAll(workoutsResponse.exercises ?? []);
          print("lfjfk");
          print(favoriteExercises.length);
          responseCode = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      responseCode = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> fetchExercises() async {
    try {
      var response = await WebServices.fetchExercises();

      print(jsonDecode(utf8.decode(response.bodyBytes)));
      if (response.statusCode == 200) {
        var workoutsResponse = ExercisesResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          print(workoutsResponse.exercises!.length);

          exercises.addAll(workoutsResponse.exercises ?? []);

          for (int i = 0; i < exercises.length; i++) {
            print("wefgyewjf");
            print(exercises[i].namedTranslations!.english);
          }
          responseCode = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      responseCode = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> fetchBodyParts() async {
    if (myBodyParts.isNotEmpty) myBodyParts.clear();
    try {
      var response = await WebServices.fetchBodyParts();

      if (response.statusCode == 200) {
        var bodyParts = BodyPartsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        print(response.body);
        myBodyParts.addAll(bodyParts.bodyParts);
      }
    } on TimeoutException catch (e) {
      responseCode = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
  }

  Future<void> setFavoriteExercise(String sessionKey, int exerciseId) async {
    try {
      var response = await WebServices.setMyFavoriteExercise(sessionKey, exerciseId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateExerciseFavoriteStatus(exerciseId);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unsetFavoriteExercise(String sessionKey, int exerciseId) async {
    try {
      var response = await WebServices.unsetMyFavoriteExercise(sessionKey, exerciseId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateExerciseFavoriteStatus(exerciseId);
      }
    } catch (e) {
      print(e);
    }
  }

  //utils
  void _updateExerciseFavoriteStatus(int id) {
    if (exercisesByBodyParts.isEmpty)
      for (int i = 0; i < exercises.length; i++) {
        if (exercises[i].id == id) {
          exercises[i].isFavorite = !exercises[i].isFavorite;
          notifyListeners();
          break;
        }
      }
    else
      for (int i = 0; i < exercisesByBodyParts.length; i++) {
        if (exercisesByBodyParts[i].id == id) {
          exercisesByBodyParts[i].isFavorite = !exercisesByBodyParts[i].isFavorite;
          notifyListeners();
          break;
        }
      }
  }

  void searchResults(String searchWord) {
    if (searchExercises.isNotEmpty) searchExercises.clear();
    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i].name == searchWord) {
        print(exercises[i].name);
        searchExercises.add(exercises[i]);
      }
    }

    notifyListeners();
  }

  void onBodyPartBressed(String bodyPart) {
    if (activeBodyPart.isEmpty || activeBodyPart != bodyPart) {
      activeBodyPart = bodyPart;
    } else if (activeBodyPart == bodyPart) {
      activeBodyPart = "";
    }
    notifyListeners();
  }
}
