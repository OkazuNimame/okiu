import 'package:flutter/material.dart';

class Clippers extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    final path1 = Path();

    path1.lineTo(size.width, 0);

    path1.lineTo(size.width, size.height);

    path1.lineTo(0, size.height);

    path1.lineTo(0, 0);

    path1.close();

    final path2 = Path();

    path2.lineTo(size.width, 0);

    path2.lineTo(size.width , size.height * 0.35);

    path2.lineTo(0, size.height * 0.7);

    path2.lineTo(0, 0);

    path2.close();

    final result = Path.combine(PathOperation.difference, path1, path2);

    return result;

    

    
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}

class ClippersTopBack extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path1 = Path();

    path1.lineTo(size.width, 0);

    path1.lineTo(size.width, size.height);

    path1.lineTo(0, size.height);

    path1.lineTo(0, 0);

    path1.close();

    final path2 = Path();

    path2.lineTo(size.width, 0);

    path2.lineTo(size.width, size.height * 0.25);

    path2.lineTo(0, size.height * 0.6);

    path2.lineTo(0, 0);

    path2.close();

    final result = Path.combine(PathOperation.difference, path1, path2);

    return result;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}