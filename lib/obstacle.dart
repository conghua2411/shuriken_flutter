import 'dart:math';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:shuriken/bullet.dart';
import 'package:shuriken/gameUtil.dart';
import 'package:shuriken/position.dart';

enum ObstacleState {
  alive,
  explosion,
  gone,
}

class Obstacle {
  Position posObstacle;

  // board width
  double bWidth;
  double bHeight;
  double limitBot;
  double limitTop;
  double obsWidth;
  double obsHeight;

  double speed;

  int timeToGone = 0;
  ObstacleState obstacleState = ObstacleState.alive;
  List<Image> imageExplosions;
  List<Image> imageNinja;
  int imageNinjaIndex = 0;

  int fireInteval;
  int fireCount = 0;

  Obstacle({@required this.bWidth,
    @required this.bHeight,
    @required this.limitBot,
    @required this.limitTop,
    @required this.obsWidth,
    @required this.obsHeight,
    @required this.speed,
    @required this.fireInteval,
    @required this.imageExplosions,
    @required this.imageNinja});

  static Obstacle generateObstacle(List<Obstacle> obstacles,
      double bWidth,
      double bHeight,
      double limitBot,
      double limitTop,
      double obsWidth,
      double obsHeight,
      double speed,
      int fireInterval,
      List<Image> imageExplosions,
      List<Image> imageNinja) {
    Obstacle obs = Obstacle(
        bWidth: bWidth,
        bHeight: bHeight,
        limitBot: limitBot,
        limitTop: limitTop,
        obsWidth: obsWidth,
        obsHeight: obsHeight,
        speed: speed,
        fireInteval: fireInterval,
        imageExplosions: imageExplosions,
        imageNinja: imageNinja);

    Random random = Random();

    bool checkCollition;
    double x, y;

    do {
      checkCollition = false;
      x = random.nextDouble() * (bWidth - obsWidth);
      y = random.nextDouble() * (limitBot - limitTop) + limitTop;

      for (Obstacle obstacle in obstacles) {
        if (collisionObstacle(x, y, obsWidth, obsHeight, obstacle)) {
          checkCollition = true;
          break;
        }
      }
    } while (checkCollition);

    obs.posObstacle = Position(dx: x, dy: y);

    return obs;
  }

  static bool collisionObstacle(double x, double y, double obsWidth,
      double obsHeight, Obstacle obstacle) {
    return GameUtil.check2RecOverlap(
        x,
        y,
        obsWidth,
        obsHeight,
        obstacle.posObstacle.dx,
        obstacle.posObstacle.dy,
        obstacle.obsWidth,
        obstacle.obsHeight);

//    if (x > obstacle.posObstacle.dx + obstacle.obsWidth ||
//        obstacle.posObstacle.dx > x + obsWidth) {
//      return false;
//    }
//
//    if (y > obstacle.posObstacle.dy + obstacle.obsHeight ||
//        y + obsHeight < obstacle.posObstacle.dy) {
//      return false;
//    }
//
//    return true;
  }

  draw(Canvas canvas) {
    if (obstacleState == ObstacleState.alive) {
      //test
//      canvas.drawRect(
//          Rect.fromLTWH(posObstacle.dx, posObstacle.dy, obsWidth, obsHeight),
//          Paint()..color = Color(0xFFFF0000));

      Image image = imageNinja[(imageNinjaIndex / 10).floor()];

      Rect src =
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      Rect dst = Rect.fromLTWH(posObstacle.dx - 10, posObstacle.dy - 10,
          obsWidth + 20, obsHeight + 20);

      canvas.drawImageRect(image, src, dst, Paint()
        ..color = Color(0xFFFFFFFF));
    } else if (obstacleState == ObstacleState.explosion) {
      Image image = imageExplosions[(timeToGone / 10).floor()];

      Rect src =
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      Rect dst = Rect.fromLTWH(posObstacle.dx - 10, posObstacle.dy - 10,
          obsWidth + 20, obsHeight + 20);

      canvas.drawImageRect(image, src, dst, Paint()
        ..color = Color(0xFFFFFFFF));
    }
  }

  bool checkCollision(Bullet bullet) {
    if (GameUtil.check2RecOverlap(
        bullet.posObject.dx - bullet.radius,
        bullet.posObject.dy - bullet.radius,
        bullet.radius * 2,
        bullet.radius * 2,
        posObstacle.dx,
        posObstacle.dy,
        obsWidth,
        obsHeight) &&
        bullet.bulletState == BulletState.flying) {
      return true;
    }
    return false;
  }

  move() {
    if (obstacleState == ObstacleState.alive) {
      checkBound();
      posObstacle.dx += speed;
      fireCount++;

      imageNinjaIndex = (imageNinjaIndex + 1) % 100;
    } else if (obstacleState == ObstacleState.explosion) {
      if (timeToGone++ > (imageExplosions.length - 1) * 10) {
        obstacleState = ObstacleState.gone;
      }
    }
  }

  void checkBound() {
    if (posObstacle.dx <= 0) {
      speed = -speed;
    }

    if (posObstacle.dx + obsWidth >= bWidth) {
      speed = -speed;
    }
  }

  Bullet createBullet(List<Image> image) {
    List<double> dir = List(2);

    dir[0] = bWidth / 2 - posObstacle.dx;
    dir[1] = (bHeight - 50) - posObstacle.dy;

    Bullet bullet = Bullet(
        posObject: Position(
            dx: posObstacle.dx + obsWidth / 2,
            dy: posObstacle.dy + obsHeight / 2 + obsHeight),
        speed: 0.007,
        radius: 15,
        direction: dir,
        bWidth: bWidth,
        paint: Paint()
          ..color = Color(0xFF00FF00),
        imageShuriken: image,
        bulletPlayer: BulletPlayer.enemy);

    return bullet;
  }

  bool isFire() {
    if (fireInteval < fireCount) {
      Random random = Random();
      fireCount = 0;
      if (random.nextInt(100) > 90) {
        return true;
      }
    }
    return false;
  }
}
