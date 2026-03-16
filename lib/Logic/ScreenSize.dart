import 'package:flutter/material.dart';

List<double> ScreenSize(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return [height, width];
}
