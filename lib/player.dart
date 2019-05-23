import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:shuriken/position.dart';

class Player {
  Position posPlayer;
  double radius;
  Paint paint;

  Position posBoundary;

  Player(
      {@required this.posPlayer, @required this.radius, @required this.paint}) {
    posBoundary = new Position(dx: posPlayer.dx, dy: posPlayer.dy);
  }

  moveTo(Position pos) {
    posPlayer.moveTo(pos);
  }

  draw(Canvas canvas) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    canvas.drawCircle(Offset(posBoundary.dx, posBoundary.dy), radius*2, paint);

    paint.style = PaintingStyle.fill;

    canvas.drawCircle(Offset(posPlayer.dx, posPlayer.dy), radius, paint);
  }

  Position calculatePosInBoundary(Position start, Position end) {
    Position pos = Position(dx: posBoundary.dx, dy: posBoundary.dy);

    double vectorX = end.dx - start.dx;
    double vectorY = end.dy - start.dy;
    
    pos.dx = pos.dx + vectorX;
    pos.dy = pos.dy + vectorY;

    return pos;
  }
}
