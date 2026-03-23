import 'dart:math';

import 'package:flutter/material.dart';
import 'package:okiu/Logic/ScreenSize.dart';

class Manegementpageanimation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Manegementpageanimation();
  }
}

class _Manegementpageanimation extends State<Manegementpageanimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.bounceOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];
    return Row(
      children: [
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(width / 2 + width *  (1 - animation.value), 0),
                child: child,
              );
            },

            child: Container(
              height: height,
              width: width / 2,

              color: Colors.lightGreenAccent,
            ),
          ),
        ),

        Align(
          alignment: AlignmentGeometry.centerRight,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: pi,
                child: Transform.translate(
                  offset: Offset(width / 2  +  width   *  (1 - animation.value), 0),
                  child: child,
                ),
              );
            },

            child: Container(
              height: height,
              width: width / 2,

              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }
}
