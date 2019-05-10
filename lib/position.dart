import 'package:meta/meta.dart';

class Position {
  double dx,dy;

  Position({@required this.dx, @required this.dy});

  add(Position pos) {
    this.dx += pos.dx;
    this.dy += pos.dy;
  }

  moveTo(Position pos) {
    this.dx = pos.dx;
    this.dy = pos.dy;
  }
}