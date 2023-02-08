import 'package:flutter_rope_sim/particle.dart';

class Spring {
  Particle a;
  Particle b;
  double k;
  double restLength;

  Spring(this.a, this.b, this.k, this.restLength);

  void update() {
    var force = b.position - a.position;
    var x = force.length - restLength;
    force.normalize();
    force.scale(k * x);
    a.applyForce(force);
    force.scale(-1);
    b.applyForce(force);
  }
}
