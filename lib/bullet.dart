import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:shuriken/gameUtil.dart';
import 'package:shuriken/position.dart';

enum BulletState { flying, stop, readyToDelete }
enum BulletPlayer { player, enemy }

class Bullet {
  Position posObject;
  double speed;
  double radius;
  List<double> direction;

  List<double> realSpeed;

  //board width
  double bWidth;
  Paint paint;

  BulletState bulletState;

  List<Image> imageShuriken;

  int countShurikenAnimation = 0;

  Image curImage;

  BulletPlayer bulletPlayer;

  int countToDelete = 0;

  Bullet(
      {@required this.posObject,
      @required this.speed,
      @required this.radius,
      @required this.direction,
      @required this.bWidth,
      @required this.paint,
      @required this.imageShuriken,
      @required this.bulletPlayer}) {
    bulletState = BulletState.flying;

//    direction = checkDirection(direction);

    realSpeed = List(2);
    realSpeed[0] = direction[0] * speed;
    realSpeed[1] = direction[1] * speed;
  }

  move() {
    if (bulletState == BulletState.flying) {
//      if (bulletPlayer == BulletPlayer.player && radius < 30) {
//        radius += 0.5;
//      }

      countShurikenAnimation = (countShurikenAnimation+1)%4;

      posObject.dx += realSpeed[0];
      posObject.dy += realSpeed[1];

      checkBound();
    } else if (bulletState == BulletState.stop) {
      if (countToDelete++ > 100) {
        bulletState = BulletState.readyToDelete;
      }
    }
  }

  void checkBound() {
    //left
    if (posObject.dx - radius <= 0) {
//      bulletState = BulletState.stop;
      realSpeed[0] = -realSpeed[0];
    }

    //right
    if (posObject.dx + radius >= bWidth) {
//      bulletState = BulletState.stop;
      realSpeed[0] = -realSpeed[0];
    }
  }

  draw(Canvas canvas) {
    if (imageShuriken == null) {
      canvas.drawCircle(Offset(posObject.dx, posObject.dy), radius, paint);
    } else {

      curImage = imageShuriken[countShurikenAnimation];

      Rect src = Rect.fromLTWH(0, 0, curImage.width.toDouble(),
          curImage.height.toDouble());
      Rect dst = Rect.fromLTWH(posObject.dx - radius,
          posObject.dy - radius, radius * 2, radius * 2);

      canvas.drawImageRect(
          curImage, src, dst, Paint()..color = Color(0xFFFFFFFF));
    }
  }

  bool checkCollisionBullet(Bullet eBullet) {
    return GameUtil.check2RecOverlap(
        posObject.dx - radius,
        posObject.dy - radius,
        radius * 2,
        radius * 2,
        eBullet.posObject.dx - eBullet.radius,
        eBullet.posObject.dy - eBullet.radius,
        eBullet.radius * 2,
        eBullet.radius * 2);
  }

  List<double> checkDirection(List<double> direction) {

    if (direction[0] > direction[1]) {
      direction[1] = direction[1]/direction[0];
      direction[0] = 1;
    } else {
      direction[0] = direction[0]/direction[1];
      direction[1] = 1;
    }

    return direction;
  }
}
