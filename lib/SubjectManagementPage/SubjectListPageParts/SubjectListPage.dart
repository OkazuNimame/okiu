import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/Logic/SubjectData/GetSubjectData.dart';
import 'package:okiu/Repo/DatabaseAccess.dart';
import 'package:okiu/SubjectManagementPage/AddSubjectPageParts/CheckMark.dart';
import 'package:okiu/SubjectManagementPage/SubjectListPageParts/SubjectListPageAnimations.dart';
import 'package:okiu/main.dart';

class Subjectlistpage extends ConsumerStatefulWidget {
  const Subjectlistpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Subjectlistpage();
  }
}

class _Subjectlistpage extends ConsumerState<Subjectlistpage> {
  late TextEditingController subjectName,
      classesNumber,
      reportsNumber,
      unitsNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    subjectName = TextEditingController();
    classesNumber = TextEditingController();
    reportsNumber = TextEditingController();
    unitsNumber = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];
    final nameCheck = ref.watch(subjectNameProvider);
    final classCheck = ref.watch(classesNumberProvider);
    final reportCheck = ref.watch(reportsNumberProvider);
    final unitCheck = ref.watch(unitsNumberProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        ref.read(subjectNameProvider.notifier).state = false;
        ref.read(classesNumberProvider.notifier).state = false;
        ref.read(reportsNumberProvider.notifier).state = false;
        ref.read(unitsNumberProvider.notifier).state = false;
        ref.read(endCheck.notifier).state = false;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            SubjectlistpageanimationsTopBack(),
            Subjectlistpageanimations(),
            SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1),

                  backContainer(
                    textField("科目名", subjectName, nameCheck, (value) {
                      if (value.isNotEmpty) {
                        ref.read(subjectNameProvider.notifier).state = true;
                      } else {
                        ref.read(subjectNameProvider.notifier).state = false;
                      }
                    }, null),
                    width,
                  ),

                  SizedBox(height: height * 0.1),

                  backContainer(
                    textField("講義数", classesNumber, classCheck, (value) {
                      if (value.isNotEmpty) {
                        ref.read(classesNumberProvider.notifier).state = true;
                      } else {
                        ref.read(classesNumberProvider.notifier).state = false;
                      }
                    }, TextInputType.number),
                    width,
                  ),

                  SizedBox(height: height * 0.1),

                  backContainer(
                    textField("レポート数", reportsNumber, reportCheck, (value) {
                      if (value.isNotEmpty) {
                        ref.read(reportsNumberProvider.notifier).state = true;
                      } else {
                        ref.read(reportsNumberProvider.notifier).state = false;
                      }
                    }, TextInputType.number),
                    width,
                  ),
                  SizedBox(height: height * 0.1),

                  backContainer(
                    textField("単位数", unitsNumber, unitCheck, (value) {
                      if (value.isNotEmpty) {
                        ref.read(unitsNumberProvider.notifier).state = true;
                      } else {
                        ref.read(unitsNumberProvider.notifier).state = false;
                      }
                    }, TextInputType.number),
                    width,
                  ),

                  SizedBox(height: height * 0.1),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameCheck &&
                            classCheck &&
                            reportCheck &&
                            unitCheck) {
                          ref
                              .read(databaseAccessProvider)
                              .insertData(
                                Getsubjectdata(
                                  subject_name: subjectName.text,
                                  classes: int.parse(classesNumber.text),
                                  report: int.parse(reportsNumber.text),
                                  unit: int.parse(unitsNumber.text),
                                  check: 0,
                                ).toMap(),
                              );

                          if (mounted) {
                            ref.read(subjectNameProvider.notifier).state =
                                false;
                            ref.read(classesNumberProvider.notifier).state =
                                false;
                            ref.read(reportsNumberProvider.notifier).state =
                                false;
                            ref.read(unitsNumberProvider.notifier).state =
                                false;
                            ref.read(endCheck.notifier).state = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Text('保存できませんでした。正しい値を入力してください'),
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                            fontSize: width * 0.08,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget backContainer(Widget child, double width) {
  return Container(
    padding: EdgeInsets.all(5),
    width: width * 0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: Colors.black, width: 2),
      color: Color(0xFFffdead),
    ),
    child: child,
  );
}

Widget textField(
  String text,
  TextEditingController con,
  bool check,
  Function(String) onChanged,
  TextInputType? textInputType,
) {
  return TextField(
    onChanged: onChanged,
    keyboardType: textInputType,
    inputFormatters: textInputType != null
        ? [FilteringTextInputFormatter.digitsOnly]
        : [],
    controller: con,
    decoration: InputDecoration(
      label: Text(text),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: check ? Colors.blue : Colors.red,
        ),
      ),
      icon: check
          ? Icon(Icons.check, color: Colors.green)
          : Icon(Icons.close, color: Colors.red),
    ),
  );
}
