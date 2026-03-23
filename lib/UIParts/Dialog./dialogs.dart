import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog awesomeDialog(
  BuildContext context,
  String title,
  String desc,
  DialogType d,
) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.bottomSlide,
    title: title,
    desc: desc,
    dialogType: d,
  )..show();
}

AwesomeDialog collBacksDialog(
  BuildContext context,
  String title,
  String desc,
  DialogType d,
  VoidCallback v,
) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.bottomSlide,
    title: title,
    desc: desc,
    dialogType: d,
    btnOkOnPress: () {
      v();
    },
  )..show();
}

AwesomeDialog widgetDialog(
  BuildContext context,
  String title,
  String desc,
  Widget body,
  DialogType d,
  VoidCallback v,
) {
  return AwesomeDialog(
    context: context,
    title: title,
    desc: desc,
    dialogType: d,
    body: body,
    btnOkOnPress: () {
      v();
    },
  )..show();
}
