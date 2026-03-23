import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/FlameGameProvider/GameListenerProvider.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/SubjectManagementPage/AddSubjectPageParts/AddAnimation.dart';
import 'package:okiu/SubjectManagementPage/SubjectListPageParts/SubjectListPage.dart';
import 'package:okiu/UIParts/Dialog./dialogs.dart';
import 'package:okiu/UIParts/SlideButton.dart';

class Addsubjectpage extends ConsumerStatefulWidget {
  const Addsubjectpage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Addsubjectpage();
  }
}

class _Addsubjectpage extends ConsumerState<Addsubjectpage> {
  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      body: Stack(
        children: [
          Center(
            child: Container(
              height: height * 0.65,
              width: width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: LayoutBuilder(
                builder: (_, cons) {
                  return Column(
                    children: [
                      SizedBox(height: cons.maxHeight * 0.1),
                      Addanimation(
                        height: cons.maxHeight * 0.25,
                        width: cons.maxWidth * 0.8,
                      ),

                      SizedBox(height: cons.maxHeight * 0.1),

                      Container(
                        height: cons.maxHeight * 0.09,
                        width: cons.maxWidth * 0.9,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Subjectlistpage(),
                              ),
                            );
                          },

                          child: Center(
                            child: Text(
                              "Tap!",
                              style: TextStyle(
                                fontSize: cons.maxWidth * 0.1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: cons.maxHeight * 0.1),

                      Container(
                        width: cons.maxWidth * 0.9,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                        ),
                        child: Text(
                          "履修した科目を追加してください。",
                          style: TextStyle(fontSize: cons.maxWidth * 0.06),
                        ),
                      ),

                      SizedBox(height: cons.maxHeight * 0.1),

                      Slidebutton(
                        height: cons.maxHeight * 0.09,
                        width: cons.maxWidth * 0.9,
                        v: () {
                          if (ref.watch(gameListenerProvider)) {
                            awesomeDialog(
                              context,
                              "詳細ダイアログ",
                              "",
                              DialogType.info,
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
