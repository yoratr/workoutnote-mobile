import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/config%20provider.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/providers/workout%20list%20%20provider.dart';
import 'package:workoutnote/ui/widgets/edit%20workout%20session%20%20dialog.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class WorkOutNote extends StatefulWidget {
  final height;
  final workout;
  final mode;

  WorkOutNote(this.height, this.workout, this.mode);

  @override
  _WorkOutNoteState createState() => _WorkOutNoteState();
}

class _WorkOutNoteState extends State<WorkOutNote> {
  ConfigProvider configProvider = ConfigProvider();
  MainScreenProvider mainScreenProvider = MainScreenProvider();
  CreateWorkoutProvider createWorkoutProvider = CreateWorkoutProvider();
  SearchDialogProvider dialogProvider = SearchDialogProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: true);
    createWorkoutProvider = Provider.of<CreateWorkoutProvider>(context, listen: false);
    dialogProvider = Provider.of<SearchDialogProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    int count = widget.workout.lifts!.length + 3;
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: _buildListViewWidget(count)),
    );
  }

  Widget _buildListViewWidget(int count) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: EdgeInsets.only(left: 15),
                        padding: EdgeInsets.only(top: 10.0),
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 20.0),
                          text: TextSpan(style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1), fontSize: 20), text: widget.workout.title!.isNotEmpty ? '${widget.workout.title}' : '[....]'),
                        ),
                      ),
                    ),
                    Expanded(flex: 4, child: Container()),
                    Expanded(
                      flex: widget.mode == 3 ? 2 : 1,
                      child: Container(
                          padding: EdgeInsets.only(top: 10.0, right: 10.0),
                          child: InkWell(
                            onTap: () {
                              if (widget.mode != 3) {
                                if (!widget.workout.isFavorite)
                                  mainScreenProvider.setFavoriteWorkOut(userPreferences!.getString("sessionKey") ?? "", widget.workout.id ?? -1, widget.mode).then((value) {
                                    setState(() {});
                                  });
                                else
                                  mainScreenProvider.unsetFavoriteWorkOut(userPreferences!.getString("sessionKey") ?? "", widget.workout.id ?? -1, widget.mode).then((value) {
                                    setState(() {});
                                  });
                              }
                            },
                            child: Icon(
                              !widget.workout.isFavorite ? Icons.favorite_border : Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            ),
                          )),
                    ),
                    if (widget.mode != 3)
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            await _showOptionDialog(configProvider, mainScreenProvider);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 10, right: 10.0),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              "assets/icons/menu.svg",
                              height: 15,
                              width: 50,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Divider(
                    color: Colors.black54,
                  ),
                )
              ],
            );
          } else if (index == count - 2) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 15.0, bottom: widget.mode == 1 ? 0.0 : 15.0),
              child: Text(
                "${calculateDuration(widget.workout.duration ?? 0).item1}:${calculateDuration(widget.workout.duration ?? 0).item2}:${calculateDuration(widget.workout.duration ?? 0).item3}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromRGBO(102, 51, 204, 1)),
              ),
            );
          } else if (index == count - 1) {
            if (widget.mode == 1)
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Color.fromRGBO(102, 51, 204, 1),
                  textColor: Colors.white,
                  child: Text("${repeat[configProvider.activeLanguage()]}"),
                  onPressed: () {
                    mainScreenProvider.repeatWorkoutSession(widget.workout.id ?? -1, createWorkoutProvider, dialogProvider.allExercises);
                  },
                ),
              );
            return SizedBox(
              height: 0.0,
              width: 0.0,
            );
          } else {
            index = index - 1;

            String mass = "${configProvider.getConvertedMass(widget.workout.lifts![index].liftMas ?? 0)}";
            String rm = "${configProvider.getConvertedRM(widget.workout.lifts![index].oneRepMax ?? 0)}";
            String identifier = configProvider.measureMode == KG ? "KG" : "LBS";
            return Container(margin: EdgeInsets.only(left: 15.0), padding: EdgeInsets.only(bottom: 10.0), child: Text("${index + 1}. ${widget.workout.lifts![index].exerciseName}, ${mass} ${identifier}, ${widget.workout.lifts![index].repetitions} REP, ${rm} RM"));
          }
        });
  }

  //region  dialogs
  Future<void> _showOptionDialog(ConfigProvider configProvider, MainScreenProvider mainScreenProvider) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: () async {
                        await _showEditWorkoutDialog(context, widget.workout);
                        Navigator.pop(context);
                      },
                      child: Text("${edit[configProvider.activeLanguage()]}"),
                    )),
                Divider(),
                Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: ()  async{
                      await  _showDeleteConfirmDialog();
                      Navigator.pop(context);
                      },
                      child: Text(
                        "${delete[configProvider.activeLanguage()]}",
                        style: TextStyle(color: Colors.red),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> _showEditWorkoutDialog(BuildContext context, WorkOut workOut) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return EditWorkoutSessionDialog(widget.height, workOut);
        }).then((value) {});
  }

  Future<void> _showDeleteConfirmDialog() async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return  Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(

                height: 186.2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                          margin: EdgeInsets.only(left: 50.0, right: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "삭제하면 항목별로 기록된 내용을 복구할 수 없습니다.삭제하시겠습니까?",
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Divider(),
                    Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex:5,
                              child: MaterialButton(

                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "취소",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),



                      VerticalDivider(),
                      Expanded(
                        flex :  5,
                              child: MaterialButton(

                                onPressed: () {
                                  mainScreenProvider.deleteWorkoutSession(userPreferences!.getString("sessionKey") ?? "", widget.workout.id ?? -1).then((value) {
                                    if (value) {
                                      showToast("${deleteSuccess[configProvider.activeLanguage()]}");
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: Text(
                                  "삭제",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),

          );
        });
  }
  //endregion

}
