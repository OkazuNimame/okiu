import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okiu/Logic/FlameGameProvider/GameListenerProvider.dart';
import 'package:okiu/Logic/ScreenSize.dart';
import 'package:okiu/SubjectManagementPage/ManegeMentPage/SubjectManegementList.dart';
import 'package:okiu/UIParts/Dialog./dialogs.dart';
import 'package:okiu/UIParts/MainPats/testAnimation.dart';
import 'package:okiu/UIParts/SlideButton.dart';

class SubjectmanagementPageUi extends ConsumerStatefulWidget {
  const SubjectmanagementPageUi({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SubjectmanagementPageUi();
  }
}

class _SubjectmanagementPageUi extends ConsumerState<SubjectmanagementPageUi> {
  late BackgroundAnimation2 game;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game = BackgroundAnimation2();
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenSize(context)[0];
    double width = ScreenSize(context)[1];

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, cons) {
          game = BackgroundAnimation2();

          return Stack(
            children: [
              SizedBox(
                height: cons.maxHeight,
                width: cons.maxWidth,
                child: GameWidget(game: game),
              ),

              Center(
                child: Container(
                  height: height * 0.65,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 2),
                    color: Colors.white70,
                  ),

                  child: LayoutBuilder(
                    builder: (context, cons) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: cons.maxHeight * 0.05),

                          Center(
                            child: Container(
                              height: cons.maxHeight * 0.25,
                              width: cons.maxWidth * 0.8,

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                color: Colors.white70,
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: AlignmentGeometry.center,
                                      children: [
                                        SizedBox(
                                          height: cons.maxHeight * 0.25,
                                          width: cons.maxWidth * 0.8,
                                          child: SubjectPageAnimation(),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: Colors.white70,
                                          ),
                                          child: Text(
                                            '登録科目',
                                            style: TextStyle(
                                              fontSize: width * 0.07,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                    builder: (context) =>
                                        Subjectmanegementlist(),
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
                              "追加した科目の講義数、レポート数を確認、管理ができます",
                              style: TextStyle(fontSize: cons.maxWidth * 0.06),
                            ),
                          ),

                          SizedBox(height: cons.maxHeight * 0.1),

                          Slidebutton(
                            height: cons.maxHeight * 0.09,
                            width: cons.maxWidth * 0.9,
                            v: () {
                              print(ref.watch(gameListenerProvider));
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
          );
        },
      ),
    );
  }
}

class SubjectPageAnimation extends StatefulWidget {
  const SubjectPageAnimation({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SubjectPageAnimation();
  }
}

class _SubjectPageAnimation extends State<SubjectPageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: AnimatedBuilder(
        animation: _animationController,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            // ← これ追加
            child: Image.asset(
              "assets/studytime.jpg",
              fit: BoxFit.cover, // ← 重要
            ),
          ),
        ),
        builder: (_, child) {
          return Opacity(
            opacity: _animationController.value,
            child: Transform.translate(
              offset: Offset((1 - _animationController.value) * -100, 0),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class BackgroundAnimation extends p.Forge2DGame {
  BackgroundAnimation() : super(gravity: Vector2(0, 100));

  Ground? ground;
  LeftGround? leftGround;
  RightGround? rightGround;

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt * 3);
  }

  @override
  Future<void> onLoad() async {
    await ready();
    await Future.delayed(Duration(milliseconds: 100));

    debugMode = false;
    int index = 0;
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

    add(
      TimerComponent(
        period: 0.5,
        repeat: true,
        onTick: () {
          if (index < (size.y / 80) * (size.x / 80)) {
            final letter = FallingLetter(
              fontSize: fontSizes[Random().nextInt(fontSizes.length)],
              text: textList[index % textList.length],
              color: colors[index % colors.length],
            );

            add(letter);

            // ⭐ physics warm start

            index++;
          }
        },
      ),
    );
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (ground == null) {
      ground = Ground(size: size);
      leftGround = LeftGround(size: size);
      rightGround = RightGround(size: size);

      addAll([leftGround!, rightGround!, ground!]);
    }
  }

  @override
  Color backgroundColor() => Colors.teal.shade200;
}

class FallingLetter extends p.BodyComponent<BackgroundAnimation> {
  String text;
  double fontSize;
  Color color;
  late TextPaint textPaint;

  FallingLetter({
    required this.text,
    required this.color,
    required this.fontSize,
  }) {
    textPaint = TextPaint(
      style: TextStyle(fontSize: fontSize, color: Colors.black),
    );
  }

  @override
  p.Body createBody() {
    final shape = p.CircleShape()
      ..radius =
          textPaint.getLineMetrics(text).width / 2 +
          textPaint.getLineMetrics(text).width * 0.3;

    final randomPosition = Vector2(game.size.x * Random().nextDouble(), -50);

    final bodyDef = p.BodyDef(
      position: randomPosition,
      type: p.BodyType.dynamic,
    );

    final body = world.createBody(bodyDef);

    body.createFixture(p.FixtureDef(shape, restitution: 0.5));

    // ⭐ physics warmup（最重要）
    body.setTransform(body.position + Vector2(0, 0.1), 0);

    return body;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    double radius =
        textPaint.getLineMetrics(text).width / 2 +
        textPaint.getLineMetrics(text).width * 0.3;

    // 円
    canvas.drawCircle(Offset.zero, radius, paint);

    // 文字サイズ取得
    final textWidth = textPaint.getLineMetrics(text).width;

    final textHeight = textPaint.getLineMetrics(text).height;

    // 中央配置（重要）
    final offset = Vector2(-textWidth / 2, -textHeight / 2);

    textPaint.render(canvas, text, offset);
  }
}

class Ground extends p.BodyComponent<BackgroundAnimation> {
  Vector2 size;
  Ground({required this.size});

  @override
  p.Body createBody() {
    const thickness = 1.0;

    final shape = p.PolygonShape()
      ..setAsBox(size.x / 2, thickness / 2, Vector2.zero(), 0);

    final bodyDef = p.BodyDef(
      position: Vector2(size.x / 2, size.y - thickness / 2),
      type: p.BodyType.static,
    );

    return world.createBody(bodyDef)..createFixture(p.FixtureDef(shape));
  }
}

class LeftGround extends p.BodyComponent<BackgroundAnimation> {
  Vector2 size;
  LeftGround({required this.size});
  @override
  p.Body createBody() {
    final shape = p.PolygonShape()
      ..setAsBox(0.5, size.y / 2, Vector2.zero(), 0);
    final bodyDef = p.BodyDef(
      position: Vector2(0, size.y / 2),
      type: p.BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(p.FixtureDef(shape));
  }
}

class RightGround extends p.BodyComponent<BackgroundAnimation> {
  Vector2 size;
  RightGround({required this.size});
  @override
  p.Body createBody() {
    final shape = p.PolygonShape()
      ..setAsBox(0.5, size.y / 2, Vector2.zero(), 0);
    final bodyDef = p.BodyDef(
      position: Vector2(size.x, size.y / 2),
      type: p.BodyType.static,
    );
    return world.createBody(bodyDef)..createFixture(p.FixtureDef(shape));
  }
}
