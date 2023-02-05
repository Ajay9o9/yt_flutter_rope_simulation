import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class SpringA extends StatefulWidget {
  const SpringA({Key? key}) : super(key: key);

  @override
  State<SpringA> createState() => _SpringAState();
}

class _SpringAState extends State<SpringA> {
  late v.Vector2 anchor;
  late v.Vector2 child;
  late v.Vector2 velocity;
  late v.Vector2 gravity;
  late Timer timer;
  double restLength = 300;
  @override
  void initState() {
    anchor = v.Vector2(400, 20);
    child = v.Vector2(500, 100);
    velocity = v.Vector2(0, 0);
    gravity = v.Vector2(0, 0.1);
    update();
    super.initState();
  }

  void update() {
    double k = 0.01;
    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      var force = child - anchor;
      var x = force.length - restLength;
      force.normalize();
      force.scale(-1 * k * x);

      velocity.add(force);
      velocity.add(gravity);
      child.add(velocity);
      velocity.scale(0.99);
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Flutter Demo Home Page'),
        ),
        body: InteractiveViewer(
          child: CustomPaint(
            painter: SpringPainter(anchor, child),
            child: Container(),
          ),
        ));
  }
}

class SpringPainter extends CustomPainter {
  final v.Vector2 anchor;
  final v.Vector2 child;

  SpringPainter(this.anchor, this.child);

  @override
  void paint(Canvas canvas, Size size) {
    Paint anchorPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    Paint childPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Paint linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    canvas.drawLine(
        Offset(anchor.x, anchor.y), Offset(child.x, child.y), linePaint);

    canvas.drawCircle(Offset(anchor.x, anchor.y), 20, anchorPaint);
    canvas.drawCircle(Offset(child.x, child.y), 40, childPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
