import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/GetDateTime/getDate.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/Logic/SubjectData/GetSubjectData.dart';
import 'package:okiu/Repo/DatabaseAccess.dart';
import 'package:okiu/SubjectManagementPage/ManegeMentPage/ManegementPageAnimation.dart';
import 'package:okiu/SubjectManagementPage/ManegeMentPage/SubjectManegementList.dart';
import 'package:okiu/UIParts/Dialog./dialogs.dart';

class Manegementclassandreport extends ConsumerStatefulWidget {
  Getsubjectdata data;
  Manegementclassandreport({required this.data});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Manegement();
  }
}

class _Manegement extends ConsumerState<Manegementclassandreport> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];
    final data = widget.data;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Subjectmanegementlist()),
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ref
                  .watch(subDatabaseProvider(data.id!))
                  .when(
                    data: (sub) {
                      print(sub);
                      return SizedBox(
                        height: width * 0.35,
                        child: GridView.builder(
                          itemCount: sub.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisExtent: width * 0.35,
                                mainAxisSpacing: width * 0.1,
                              ),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final subData = sub[index];
                            print("data is ${subData.checks}");
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                height: width * 0.35,
                                width: width * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  border: subData.checks == 0
                                      ? Border.all(color: Colors.red)
                                      : Border.all(color: Colors.blue),
                                ),
                                child: subData.checks == 0
                                    ? Center(child: Text("講義${index + 1}回目"))
                                    : Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),

                                            Text(subData.date),
                                          ],
                                        ),
                                      ),
                              ),
                              onTap: () async {
                                if (subData.checks == 0) {
                                  DateTime? dateTime = await getDate(context);

                                  if (dateTime != null) {
                                    String str =
                                        "${dateTime.year}/${dateTime.month}/${dateTime.day}";
                                    widgetDialog(
                                      context,
                                      "講義完了ダイアログ",
                                      "OKボタンを押してチェックしよう！",
                                      TextField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          label: Text("コメント"),
                                          icon: Icon(Icons.text_fields),
                                        ),
                                      ),
                                      DialogType.question,
                                      () {
                                        ref
                                            .read(databaseAccessProvider)
                                            .updateSubData(data.id!, index, 1);

                                        ref.invalidate(subDatabaseProvider);
                                      },
                                    );
                                  } else {
                                    print("NULL");
                                  }
                                } else {
                                  collBacksDialog(
                                    context,
                                    "完了取り消しダイアログ",
                                    "元に戻すことはできません！",
                                    DialogType.question,
                                    () {
                                      ref
                                          .read(databaseAccessProvider)
                                          .deleteClassCheck(data.id!, index);

                                      ref.invalidate(subDatabaseProvider);
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) => Text("$error"),
                    loading: () => CircularProgressIndicator(),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
