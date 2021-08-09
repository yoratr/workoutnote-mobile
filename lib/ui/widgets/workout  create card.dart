import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class CreateWorkOutCard extends StatelessWidget {
  var titleContoller = TextEditingController();
  final width;
  final height;

  CreateWorkOutCard(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    return Container(
      child: Consumer<MainScreenProvider>(builder: (context, exProvider, child) {
        if (!exProvider.timeRefreshed && userPreferences!.getInt("time") != null) {
          exProvider.timeRefreshed = true;
          exProvider.hrs = ((userPreferences!.getInt("time")! / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          exProvider.mins = ((userPreferences!.getInt("time")! / 60) % 60).floor().toString().padLeft(2, '0');
          exProvider.secs = (userPreferences!.getInt("time")! % 60).floor().toString().padLeft(2, '0');
        }
        int count = exProvider.selectedExercises.length + 7;
        if (!exProvider.appRefereshed) exProvider.firstEnterApp();
        print(count);
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            elevation: 10,
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (BuildContext context, int index) {
                    if (index > 4 && index != count - 2)
                      return Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(
                          height: 1,
                          color: Colors.black54,
                        ),
                      );
                    else
                      return Divider(
                        height: 0,
                        color: Colors.white,
                      );
                  },
                  itemCount: count,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                          margin: EdgeInsets.only(left: 20),
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ));
                    else if (index == 1)
                      return Container(
                        margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10),
                        child: TextFormField(
                          onChanged: (c) async {
                            await exProvider.saveTitleToSharedPreference(c);
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 5.0),
                            hintText: "${title[configProvider.activeLanguage()]}",
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                          ),
                          controller: exProvider.titleContoller,
                        ),
                      );
                    else if (index == 2) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: 15.0),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "${exProvider.hrs}:${exProvider.mins}:${exProvider.secs}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40, color: Color.fromRGBO(102, 51, 204, 1)),
                              ),
                            ),
                            Spacer(),
                            if (exProvider.timerSubscription != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: IconButton(
                                    onPressed: () {
                                      exProvider.stopTimer();
                                    },
                                    icon: Icon(
                                      Icons.stop_circle_outlined,
                                      color: Color.fromRGBO(102, 51, 204, 1),
                                      size: 50,
                                    )),
                              ),
                            Container(
                              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                              child: (exProvider.timerSubscription == null || exProvider.timerSubscription!.isPaused)
                                  ? IconButton(
                                      onPressed: () {
                                        if (exProvider.timerSubscription == null) {
                                          print("start timer");
                                          exProvider.startTimer();
                                        } else if (exProvider.timerSubscription!.isPaused) {
                                          exProvider.resumeTimer();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.play_circle_outline,
                                        color: Color.fromRGBO(102, 51, 204, 1),
                                        size: 50,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        exProvider.pauseTimer();
                                      },
                                      icon: Icon(
                                        Icons.pause_circle_outline,
                                        color: Color.fromRGBO(102, 51, 204, 1),
                                        size: 50,
                                      )),
                            ),
                          ],
                        ),
                      );
                    } else if (index == 3) {
                      return Container(
                        margin: EdgeInsets.only(left: 20.0, top: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            color: Color.fromRGBO(102, 51, 204, 1),
                            onPressed: () async {
                              await _showdialog(context, configProvider);
                            },
                            textColor: Colors.white,
                            child: Text("${seeExercises[configProvider.activeLanguage()]}"),
                          ),
                        ),
                      );
                    } else if (index == 4) {
                      return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(231, 223, 247, 1),
                              border: Border.all(
                                color: Color.fromRGBO(230, 230, 250, 1),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: _buildExerciseListItem("No.", "${exercisesName[configProvider.activeLanguage()]}", "KG", "REP", "RM", Color.fromRGBO(102, 51, 204, 1), 1, exProvider, index, context, configProvider));
                    } else if (index == count - 2) {
                      return Container(
                          padding: EdgeInsets.only(left: 10, right: 10.0),
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: _buildExerciseListItem("", "${exProvider.unselectedExercise == null ? "dummy" : exProvider.unselectedExercise!.name}(${(exProvider.unselectedExercise == null ? "" : exProvider.unselectedExercise!.bodyPart)})", "KG",
                              "REP", "RM", Colors.grey, 3, exProvider, index, context, configProvider));
                    } else if (index > 4 && index < count - 2 && index < count - 1) {
                      index = index - 5;
                      return Container(
                          padding: EdgeInsets.only(left: 10, right: 10.0),
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: _buildExerciseListItem(
                              (index + 1).toString(), "${exProvider.selectedExercises[index].exerciseName}(${exProvider.selectedExercises[index].bodyPart})", "100KG", "1", "1.0", Colors.black, 2, exProvider, index, context, configProvider));
                    } else
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              width: 100,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                color: Color.fromRGBO(102, 51, 204, 1),
                                onPressed: () async {
                                  exProvider.removeExercises();
                                  await exProvider.saveListToSharePreference();
                                },
                                textColor: Colors.white,
                                child: Text("${remove[configProvider.activeLanguage()]}"),
                              ),
                            ),
                            Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 10.0),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                                color: Color.fromRGBO(102, 51, 204, 1),
                                onPressed: () async {
                                  await exProvider.createWorkOutSession(userPreferences!.getString("sessionKey") ?? "fuck", exProvider.titleContoller.text, DateTime.now().microsecondsSinceEpoch);
                                  await exProvider.saveListToSharePreference();
                                },
                                textColor: Colors.white,
                                child: Text("${save[configProvider.activeLanguage()]}"),
                              ),
                            ),
                          ],
                        ),
                      );
                  }),
            ));
      }),
    );
  }

  Future<void> _showdialog(BuildContext context, ConfigProvider configProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MainScreenProvider>(builder: (context, exProvider, child) {
            if (!exProvider.requestDone2) {
              exProvider.requestDone2 = true;
              exProvider.fetchBodyParts().then((value) {});
              exProvider.fetchExercises().then((value) {});
            }
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              insetPadding: EdgeInsets.all(20),
              child: Container(
                height: 0.9 * height,
                child: Scrollbar(
                    thickness: 3,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (index == 0)
                            return Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${exercises[configProvider.activeLanguage()]}",
                                      style: TextStyle(fontSize: 21, color: Colors.deepPurpleAccent),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
                              ),
                            );
                          else if (index == 1)
                            return Container(
                              height: 40,
                              margin: EdgeInsets.only(left: 10, right: 10.0),
                              child: TextFormField(
                                controller: exProvider.searchController,
                                onChanged: (searchWord) {
                                  exProvider.searchResults(searchWord);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => exProvider.searchController.clear(),
                                    icon: Icon(Icons.clear, color: Colors.deepPurpleAccent),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(5),
                                  // Added this
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            );
                          else if (index == 2) {
                            return Container(
                              height: height * 0.1,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(exProvider.bodyParts.length, (index) {
                                    if (index == 0) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                        child: InkWell(
                                            onTap: () {},
                                            child: Chip(
                                              label: Text(
                                                "Favorites",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            )),
                                      );
                                    } else {
                                      index = index - 1;
                                      return Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: InkWell(
                                              onTap: () {
                                                exProvider.onBodyPartBressed(exProvider.bodyParts[index].name);
                                              },
                                              child: Chip(
                                                label: Text(exProvider.bodyParts[index].name),
                                                backgroundColor: exProvider.activeBodyPart == exProvider.bodyParts[index].name ? Colors.grey : Colors.black12,
                                              )));
                                    }
                                  })),
                            );
                          } else {
                            index = index - 3;
                            return InkWell(
                              onTap: () {
                                if (exProvider.exercisesByBodyParts.isEmpty)
                                  exProvider.unselectedExercise = exProvider.exercises[index];
                                else
                                  exProvider.unselectedExercise = exProvider.exercisesByBodyParts[index];
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 8,
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Text(
                                                "${exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises[index].name : exProvider.exercisesByBodyParts[index].name} (${exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises[index].bodyPart : exProvider.exercisesByBodyParts[index].bodyPart})"))),
                                    Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return Divider(
                            color: index > 2 ? Colors.grey : Colors.white,
                          );
                        },
                        itemCount: exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises.length + 3 : exProvider.exercisesByBodyParts.length + 3)),
              ),
            );
          });
        });
  }

  Widget _buildExerciseListItem(String exerciseNumber, String exerciseName, String kg, String rep, String rm, Color color, int mode, MainScreenProvider mainScreenProvider, int index, BuildContext context, ConfigProvider configProvider) {



    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: 5.0),
            child: Text(
              exerciseNumber,
              style: TextStyle(color: color),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async {
              if (mode == 1) {

              } else if (mode == 2) {
                mainScreenProvider.unselectedExercise = Exercise(mainScreenProvider.selectedExercises[index].exerciseId, mainScreenProvider.selectedExercises[index].exerciseName, mainScreenProvider.selectedExercises[index].bodyPart, "");
              } else {
                await _showdialog(context, configProvider);
              }
            },
            child: Container(
              child: Text(
                exerciseName,
                style: TextStyle(color: color),
              ),
            ),
          ),
        ),
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 2,
          child:

          mode == 2? DropdownButton<int>(
            isExpanded:true,
            underline: SizedBox(),
            iconSize: 0.0,
            value:   mainScreenProvider.selectedExercises[index].mass,
            onChanged: (newValue) {
              print(newValue);
              mainScreenProvider.updateMass(index, newValue!);
            },
            items:  mainScreenProvider.selectedExercises[index].kgs.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("${value}kg"),
              );
            }).toList(),
          ):Text("KG",  style: TextStyle(
           color: mode == 1?  Color.fromRGBO(102, 51, 204, 1):Colors.grey
         ),),
        ),
        Expanded(
          flex: 2,
          child:
          mode ==2? DropdownButton<int>(
            isExpanded:true,
            underline: SizedBox(),
            iconSize: 0.0,
            value: mainScreenProvider.selectedExercises[index].rep,
            onChanged: (newValue) {
              mainScreenProvider.updateRep(index, newValue!);

            },
            items:  mainScreenProvider.selectedExercises[index].reps.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          ):Text("REP", style: TextStyle(
             color: mode == 1?  Color.fromRGBO(102, 51, 204, 1):Colors.grey
         ),),
        ),
        Expanded(
          flex: 2,
          child: Container(
            child: Text(
              rm.toString(),
              style: TextStyle(color: color),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: mode == 1
              ? Container()
              : (mode == 2
                  ? IconButton(
                      onPressed: () async {
                        mainScreenProvider.updateExercise(index);
                        mainScreenProvider.saveListToSharePreference();
                      },
                      icon: mainScreenProvider.selectedExercises[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: Color.fromRGBO(102, 51, 204, 1),
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.grey,
                            ))
                  : IconButton(
                      onPressed: () async {
                        if (mainScreenProvider.unselectedExercise != null) {
                          mainScreenProvider.addExercise(EditableLift.create(mainScreenProvider.unselectedExercise!.name, mainScreenProvider.unselectedExercise!.id, mainScreenProvider.unselectedExercise!.bodyPart, 1, 1, true));
                          await mainScreenProvider.saveListToSharePreference();
                        } else
                          showToast("Please, select exercise!");
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                        size: 30,
                      ),
                    )),
        )
      ],
    );
  }
}
