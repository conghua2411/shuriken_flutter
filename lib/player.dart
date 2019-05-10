import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:shuriken/position.dart';

class Player {
  Position posPlayer;
  double radius;
  Paint paint;

  Player(
      {@required this.posPlayer, @required this.radius, @required this.paint});

  moveTo(Position pos) {
    posPlayer.moveTo(pos);
  }

  draw(Canvas canvas) {
    canvas.drawCircle(Offset(posPlayer.dx, posPlayer.dy), radius, paint);
  }
}
