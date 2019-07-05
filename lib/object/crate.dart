import 'dart:math';
import 'dart:ui';

import 'package:flame/position.dart';

class Crate {
  Position pos;

  double height;
  double width;

  Image imgCrate;

  Crate({this.pos, this.width, this.height, this.imgCrate});

  draw(Canvas canvas) {
    if (imgCrate == null) {
      canvas.drawRect(Rect.fromLTWH(pos.x, pos.y, width, height),
          Paint()..color = Color(0xffffff00));
    } else {
      Rect src = Rect.fromLTWH(
          0, 0, imgCrate.width.toDouble(), imgCrate.height.toDouble());

      Rect dst = Rect.fromLTWH(pos.x, pos.y, width, height);

      canvas.drawImageRect(
          imgCrate, src, dst, Paint()..color = Color(0xffffffff));
    }
  }

  static Crate generateCrate(double bWidth, double bHeight, double limitTop,
      double limitBot, double crateWidth, double crateHeight, Image imgCrate) {
    //generate pos
    Random rand = Random();

    double x = rand.nextDouble() * (bWidth - crateWidth);
    double y = rand.nextDouble() * (limitBot - limitTop) + limitTop;

    return Crate(
        pos: Position(x, y),
        width: crateWidth,
        height: crateHeight,
        imgCrate: imgCrate);
  }
}
