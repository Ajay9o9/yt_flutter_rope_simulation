import 'package:vector_math/vector_math_64.dart';

class Particle {
  late Vector2 acceleration;
  late Vector2 position;
  late Vector2 velocity;
  late double mass;
  late bool fixed;

  Particle(double x, double y) {
    acceleration = Vector2(0, 0);
    position = Vector2(x, y);
    velocity = Vector2(0, 0);
    mass = 10;
    fixed = false;
  }

  updatePosition(x, y) {
    position = Vector2(x, y);
  }

  updateVelocity(x, y) {
    velocity = Vector2(x, y);
  }

  applyForce(Vector2 force) {
    force /= mass;
    acceleration += force;
  }

  update() {
    if (fixed) return;
    velocity *= 0.99;
    velocity += acceleration;
    position += velocity;
    acceleration *= 0;
  }
}
