import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

AwesomeDialog awesomeDialog(BuildContext context, String title, String desc, DialogType d) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.bottomSlide,
    title: title,
    desc: desc,
    dialogType: d,
  )..show();
}
