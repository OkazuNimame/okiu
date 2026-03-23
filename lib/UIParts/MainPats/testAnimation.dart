import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class BackgroundAnimation2 extends FlameGame with HasCollisionDetection {
  final random = Random();

  List<String> textList = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "1",
    "2",
    "3",
    "4",
    "5",
    "あ",
    "い",
    "う",
    "え",
    "お",
  ];

  List<double> fontSizes = [20, 25, 30, 35, 40, 45, 50, 60, 70, 80];

  List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.pink,
    Colors.cyanAccent,
    Colors.teal,
    Colors.green,
    Colors.lightBlueAccent,
    Colors.yellowAccent,
  ];

  @override
  Future<void> onLoad() async {
    add(
      TimerComponent(
        period: 0.3,
        repeat: true,
        onTick: () {
          if (children.length < 20) {
            add(
              FallingLetter(
                text: textList[children.length % textList.length],
                fontSize: fontSizes[children.length % fontSizes.length],
                color: colors[children.length % colors.length],
              )..anchor = Anchor.center,
            );
          }
        },
      ),
    );
  }

  @override
  Color backgroundColor() => Colors.teal.shade200;
}

class FallingLetter extends PositionComponent
    with CollisionCallbacks, HasGameReference<BackgroundAnimation2> {
  final String text;
  final double fontSize;
  final Color color;

  late TextPaint textPaint;

  late double textWidth;
  late double textHeight;

  Vector2 velocity = Vector2(0, 200);
  final double gravity = 500; // 重力
  final double bounce = 0.6; // バウンド係数

  FallingLetter({
    required this.text,
    required this.fontSize,
    required this.color,
  });

  @override
  FutureOr<void> onLoad() {
    textPaint = TextPaint(
      style: TextStyle(fontSize: fontSize, color: color),
    );

    final textSize = textPaint.getLineMetrics(text);

    textWidth = textSize.width;
    textHeight = textSize.height;

    // 初期位置
    position = Vector2(game.size.x * Random().nextDouble(), 0);

    

    if(position.y >= game.size.y - textWidth / 2) {
      explode();
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);

    canvas.drawCircle(
      Offset.zero,
      textWidth,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke..strokeWidth = 5,
    );

    textPaint.render(canvas, text, Vector2(-textWidth / 2, -textHeight / 2));
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    velocity.y += gravity * dt;

    position += velocity * dt;

    if (position.y <= 0 || position.y >= game.size.y) {
      velocity.y *= -1;
    }
  }
void explode() {
  final count = 20;
  final rand = Random();

  for (int i = 0; i < count; i++) {
    final angle = rand.nextDouble() * 2 * pi;
    final speed = rand.nextDouble() * 300 + 100;

    final velocity = Vector2(
      cos(angle) * speed,
      sin(angle) * speed,
    );

    game.add(
      ParticleLetter(
        position: position,
        velocity: velocity,
        color: color
      ),
    );
  }

  removeFromParent(); // 元の文字消す
}
 
}

class ParticleLetter extends PositionComponent {
  Vector2 velocity;
  double life = 1.0;
  Color color;

  ParticleLetter({
    required Vector2 position,
    required this.velocity,
    required this.color
  }) {
    this.position = position.clone();
    anchor = Anchor.center;
    size = Vector2.all(4); // 小さい粒
  }

  @override
  void update(double dt) {
    super.update(dt);

    position += velocity * dt;
    velocity *= 0.95; // 減速
    life -= dt;

    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      2,
      Paint()..color = color.withAlpha((life * 100).toInt())
    );
  }
}
