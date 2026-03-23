import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/UIParts/Clips/Clippers.dart';

class Subjectlistpageanimations extends ConsumerStatefulWidget {
  @override
  ConsumerState<Subjectlistpageanimations> createState() {
    return _Subjectlistpageanimations();
  }
}

class _Subjectlistpageanimations
    extends ConsumerState<Subjectlistpageanimations>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  Animation<double>? animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(endCheck) && _animationController != null) {
      _animationController!.forward();
    }
    double height = ScreenSize(context)[0];

    double width = ScreenSize(context)[1];
    return _animationController != null && animation != null
        ? AnimatedBuilder(
            animation: _animationController!,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -height * (1 - animation!.value)),
                child: child,
              );
            },
            child: ClipPath(
              clipper: Clippers(),
              child: Container(
                height: height,
                width: width,
                color: Colors.orange,
              ),
            ),
          )
        : Container();
  }
}

class SubjectlistpageanimationsTopBack extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubjectlistpageanimationsTopBack();
  }
}

class _SubjectlistpageanimationsTopBack
    extends ConsumerState<SubjectlistpageanimationsTopBack>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut, // ←これがバウンド
      ),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ref.read(endCheck.notifier).state = true;
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];

    double width = ScreenSize(context)[1];
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -height * (1 - animation.value)),
          child: child,
        );
      },
      child: Transform.rotate(
        angle: pi,
        child: ClipPath(
          clipper: ClippersTopBack(),
          child: Container(height: height, width: width, color: Colors.blue),
        ),
      ),
    );
  }
}

final endCheck = StateProvider((ref) => false);
