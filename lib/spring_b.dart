import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rope_sim/particle.dart';
import 'package:flutter_rope_sim/spring.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class SpringB extends StatefulWidget {
  const SpringB({Key? key}) : super(key: key);

  @override
  State<SpringB> createState() => _SpringBState();
}

class _SpringBState extends State<SpringB> {
  late v.Vector2 gravity;
  late Timer timer;
  double restLength = 200;
  double spacing = 20;
  late List<Particle> _particles;
  late List<Spring> _springs;

  late int noOfParticles;
  double k = 0.1;

  @override
  void initState() {
    noOfParticles = 10;
    _particles = List<Particle>.filled(noOfParticles, Particle(0, 0));
    _springs = List<Spring>.filled(
        noOfParticles,
        Spring(
          _particles[0],
          _particles[1],
          0,
          0,
        ));

    gravity = v.Vector2(0, 0.1);

    for (int i = 0; i < noOfParticles; i++) {
      _particles[i] = Particle(70 + i * spacing, 80 + i * spacing);

      if (i != 0) {
        var a = _particles[i];
        var b = _particles[i - 1];
        var spring = Spring(a, b, k, restLength);
        _springs[i] = spring;
      }
    }

    _particles.first.fixed = true;
    _particles.last.fixed = true;

    update();
    super.initState();
  }

  void update() {
    timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      for (var spring in _springs) {
        spring.update();
      }

      for (var particle in _particles) {
        particle.applyForce(gravity);
        particle.update();
      }

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
        body: GestureDetector(
          onPanUpdate: (details) {
            Offset tapPosition = details.localPosition;
            var bob = _particles[_particles.length - 1];
            bob.updatePosition(tapPosition.dx, tapPosition.dy);
            bob.updateVelocity(0, 0);
          },
          child: CustomPaint(
            painter: SpringPainter(_particles),
            child: Container(),
          ),
        ));
  }
}

class SpringPainter extends CustomPainter {
  late List<Particle> _particles;

  SpringPainter(
    this._particles,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var head = _particles[0];
    var tail = _particles[_particles.length - 1];

    var paint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.fill;

    var line = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    var path = Path();
    path.moveTo(head.position.x, head.position.y);

    for (var i = 1; i < _particles.length - 1; i++) {
      var p = _particles[i];
      var nextP = _particles[i + 1];

      var midPoint = p.position + (nextP.position - p.position) * 0.69;

      path.quadraticBezierTo(
          p.position.x, p.position.y, midPoint.x, midPoint.y);
    }

    path.lineTo(tail.position.x, tail.position.y);

    canvas.drawPath(path, line);

    canvas.drawCircle(Offset(tail.position.x, tail.position.y), 32, paint);
    canvas.drawCircle(Offset(head.position.x, head.position.y), 32, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
