import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/FlameGameProvider/GameListenerProvider.dart';

class Slidebutton extends ConsumerWidget {
  final double height;
  final double width;
  VoidCallback v;

  Slidebutton({super.key, required this.height, required this.width, required this.v});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey),
            child: Center(
              child: Text("スライドして詳細表示！", style: TextStyle(fontSize: width * 0.05)),
            ),
          ),

          GameWidget(
            game: SlideAnimation(
              context: context,
              ref: ref,
              v: () {
                v();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SlideAnimation extends FlameGame with HasCollisionDetection {
  final BuildContext context;
  VoidCallback v;

  DraggableCircle? circle;
  DraggBackGround? background;
  WidgetRef ref;

  SlideAnimation({required this.context, required this.ref, required this.v});

  @override
  Future<void> onLoad() async {
    background = DraggBackGround();
    circle = DraggableCircle(background: background!, context: context, ref: ref, v: v);

    if (background != null && circle != null) {
      add(background!);
      add(circle!);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    final radius = gameSize.x / 9;

    if (background != null && circle != null) {
      // 背景バー
      background!
        ..size = Vector2(gameSize.x, gameSize.y)
        ..position = Vector2(0, gameSize.y / 2)
        ..anchor = Anchor.centerLeft;

      // 円
      circle!
        ..size = gameSize
        ..position = Vector2(radius, gameSize.y / 2)
        ..anchor = Anchor.center;
    }
  }

  @override
  Color backgroundColor() => Colors.transparent;
}

class DraggableCircle extends PositionComponent with DragCallbacks {
  final DraggBackGround background;
  final BuildContext context;

  late double radius;
  late Vector2 Gsize;
  late WidgetRef ref;
  VoidCallback v;

  bool triggered = false;

  DraggableCircle({
    required this.background,
    required this.context,
    required this.ref,
    required this.v,
  });

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

    radius = gameSize.x / 9;
    Gsize = gameSize;

    add(CircleHitbox(radius: radius, position: position));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(Offset(Gsize.x / 2, Gsize.y / 2), radius, Paint()..color = Colors.blue);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position.x += event.canvasDelta.x;

    final minX = radius;
    final maxX = Gsize.x - radius;

    position.x = position.x.clamp(minX, maxX);

    final rate = ((position.x - minX) / (maxX - minX)).clamp(0.0, 1.0);

    print(rate);

    background.progress = rate;

    if (rate >= 0.99 && !triggered) {
      triggered = true;
      ref.read(gameListenerProvider.notifier).state = triggered;
      v.call();
      position.x = minX;
      background.progress = 0.0;
      triggered = false;
    }
  }
}

class DraggBackGround extends PositionComponent {
  double progress = 0.0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x * progress, size.y),
      const Radius.circular(100),
    );

    canvas.drawRRect(rrect, paint);
  }
}
