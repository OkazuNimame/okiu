import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class Addanimation extends StatefulWidget {
  double height, width;
  Addanimation({super.key, required this.height, required this.width});
  @override
  State<StatefulWidget> createState() {
    return _Addanimation();
  }
}

class _Addanimation extends State<Addanimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 5,
          color: Colors.black,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Stack(
          children: [
            GameWidget(game: AddShower()),
            GameWidget(game: Animations()),
          ],
        ),
      ),
    );
  }
}

class Animations extends FlameGame {
  RotatingText? rotatingText;

  @override
  FutureOr<void> onLoad() {
    List<String> texts = ["科", "目", "追", "加"];
    List<double> interval = [1, 2, 3, 4];
    int index = 0;

    add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          if (index < 4) {
            add(RotatingText(text: texts[index], interval: interval[index]));

            index++;
          }
        },
      ),
    );

    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return Colors.transparent;
  }
}

class RotatingText extends TextComponent {
  @override
  String text;
  double interval;
  RotatingText({required this.text, required this.interval})
    : super(
        text: text,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 40, color: Colors.black),
        ),
      );

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    final gameSize = findGame()!.size;

    // 最初（右下）
    position = Vector2(gameSize.x + 40, gameSize.y / 2);

    double textWidth = textRenderer.getLineMetrics(text).width;
    double allTextWidth = textWidth * 4;
    double startWidth = (gameSize.x - allTextWidth) / 2 - textWidth / 2;
    Vector2 target = Vector2(startWidth + textWidth * interval, gameSize.y / 2);

    print(target);
    print(gameSize.x);
    print(textWidth);

    // 中央

    add(
      MoveEffect.to(
        target,
        EffectController(duration: 1, curve: Curves.easeOut),
      ),
    );
    add(RotateEffect.to(pi * 2, EffectController(duration: 1)));
  }
}

class AddShower extends FlameGame with HasCollisionDetection {
  int maxBubbles = 60;
  AddBubbles? addBubbles;
  @override
  Future<void> onLoad() async {
    final gameSize = size;

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
    add(Floor()..size = gameSize);

    add(
      TimerComponent(
        period: 0.1,
        repeat: true,
        onTick: () {
          // 👇 現在の泡の数をチェック
          if (children.whereType<AddBubbles>().length >= maxBubbles) {
            return;
          }

          final x = Random().nextDouble() * gameSize.x;

          add(
            AddBubbles(
                color: colors[Random().nextInt(colors.length)],
                interval: x,
              )
              ..size = Vector2.all(gameSize.x / 20)
              ..anchor = Anchor.center
              ..position = Vector2(x, 0),
          );
        },
      ),
    );
  }

  @override
  Color backgroundColor() {
    return Colors.white;
  }
}

class AddBubbles extends PositionComponent with CollisionCallbacks {
  Color color;
  double interval;
  AddBubbles({required this.color, required this.interval});

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    add(CircleHitbox());
    
  }

  @override
  void render(Canvas canvas) {
    // TODO: implement render
    super.render(canvas);

    canvas.drawCircle(
      Offset.zero,
      size.x / 3,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    position.y += 100 * dt;
  }


  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    print("hit!");
  }
}

class Floor extends PositionComponent with CollisionCallbacks {
  @override
  Future<void> onLoad() async {
    final gameSize = findGame()!.size;

    size = Vector2(gameSize.x, 20); // 幅ちゃんと取る
    position = Vector2(0, gameSize.y - 20);

    add(RectangleHitbox());
  }
}