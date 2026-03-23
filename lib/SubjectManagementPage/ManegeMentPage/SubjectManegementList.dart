import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/Logic/SubjectData/GetSubjectData.dart';
import 'package:okiu/Repo/DatabaseAccess.dart';
import 'package:okiu/SubjectManagementPage/ManegeMentPage/ManegementClassAndReport.dart';
import 'package:okiu/SubjectManagementPage/ManegeMentPage/ManegementPageAnimation.dart';
import 'package:okiu/UIParts/Dialog./dialogs.dart';
import 'package:okiu/main.dart';

class Subjectmanegementlist extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Subjectmanegementlist();
  }
}

class _Subjectmanegementlist extends ConsumerState<Subjectmanegementlist> {
  @override
  Widget build(BuildContext context) {
    ref.invalidate(usersProvider);
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            Manegementpageanimation(),
            Center(
              child: Container(
                height: height * 0.8,

                width: width * 0.9,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),

                  color: Colors.white54,
                ),

                child: ref
                    .watch(usersProvider)
                    .when(
                      data: (users) {
                        return users.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.only(top: 10),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  print("data is $users");
                                  String subjectName =
                                      users[index].subject_name;
                                  int classes = users[index].classes,
                                      report = users[index].report,
                                      unit = users[index].unit,
                                      check = users[index].check;

                                  int? id = users[index].id;

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.subject_sharp),
                                      title: check == 0
                                          ? Text(
                                              subjectName,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          : Text.rich(
                                              TextSpan(
                                                text: subjectName,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: "合格！",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      subtitle: Text(
                                        "講義数：$classes, レポート数：$report",
                                      ),

                                      titleTextStyle: TextStyle(
                                        fontSize: width * 0.09,
                                      ),

                                      onTap: () async {
                                        final subData = await ref
                                            .read(databaseAccessProvider)
                                            .getSubData(id!);

                                            
                                        if (subData.isNotEmpty) {
                                        } else {
                                          for (int i = 0; i == classes; i++) {
                                            ref
                                                .read(databaseAccessProvider)
                                                .subDatabaseInsert(
                                                  SubDatabaseLogic(
                                                    subject_id: id,
                                                    class_index: i,
                                                    checks: 0,
                                                    text: "",
                                                    date: "",
                                                  ).toMap(),
                                                );
                                            ref.invalidate(
                                              subDatabaseProvider(id),
                                            );
                                          }
                                        }

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Manegementclassandreport(
                                                  data: users[index],
                                                ),
                                          ),
                                        );
                                      },

                                      onLongPress: () async {
                                        print(id);
                                        collBacksDialog(
                                          context,
                                          "削除確認",
                                          "削除すると復元はできません",
                                          DialogType.question,
                                          () async {
                                            if (id != null) {
                                              ref
                                                  .read(databaseAccessProvider)
                                                  .deleteData(id);

                                              ref.invalidate(usersProvider);
                                            } else {
                                              print("error");
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: 'デ|タがありません！'
                                    .split('')
                                    .map(
                                      (c) => Text(
                                        c,
                                        style: TextStyle(fontSize: width * 0.1),
                                      ),
                                    )
                                    .toList(),
                              );
                      },
                      error: (e, _) => Center(child: Text("エラーです！")),
                      loading: () {
                        return CircularProgressIndicator();
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
