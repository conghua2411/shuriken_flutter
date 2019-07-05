import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:shuriken/bullet.dart';
import 'package:shuriken/gameUtil.dart';
import 'package:shuriken/object/crate.dart';
import 'package:shuriken/obstacle.dart';
import 'package:shuriken/player.dart';
import 'package:shuriken/position.dart';

class Shuriken {
  Size dimension;

  Paint paintPlayer;
  Player player;

  List<Position> direction;

  List<Bullet> bullets;
  Paint paintBullet;

  List<Bullet> enemyBullets;
  Paint paintEnemyBullets;

  List<Obstacle> obstacles;

  List<Image> imageNinja;

  Random random;

  List<Image> imageExplosions;

  List<Image> imageShuriken;

  List<Crate> listCrate;

  Image imgCrate;

  Shuriken(this.dimension) {
    paintPlayer = Paint()..color = Color(0xFFFF0000);
    paintBullet = Paint()..color = Color(0xFF00FFFF);

    enemyBullets = List();
    paintEnemyBullets = Paint()..color = Color(0xFF00FF00);

    player = Player(
        posPlayer: Position(dx: dimension.width / 2, dy: dimension.height - 70),
        radius: 50,
        paint: paintPlayer);

    bullets = List();

    direction = List();

    obstacles = List();

    listCrate = List();

    random = Random();

    loadImageExplosion();

    loadImageNinja();

    loadImageShuriken();

    loadImageCrate();
  }

  Future loadImageCrate() async {
    imgCrate = await Flame.images.load('crate.png');
  }

  Future loadImageExplosion() async {
    imageExplosions = List();

    imageExplosions.add(await Flame.images.load('ninja/ninja_death.png'));
    imageExplosions.add(await Flame.images.load('ninja/ninja_death.png'));
    imageExplosions.add(await Flame.images.load('ninja/ninja_death.png'));
    imageExplosions.add(await Flame.images.load('ninja/ninja_death.png'));

    for (int i = 0; i <= 6; i++) {
      imageExplosions
          .add(await Flame.images.load('explosion-' + i.toString() + '.png'));
    }
  }

  Future loadImageNinja() async {
    imageNinja = List();

    for (int i = 0; i <= 9; i++) {
      imageNinja
          .add(await Flame.images.load('ninja/ninja' + i.toString() + '.png'));
    }
  }

  Future loadImageShuriken() async {
    imageShuriken = List();

//    imageShuriken.add(await Flame.images.load('ninja/shuriken.png'));

    for (int i = 0; i <= 3; i++) {
      imageShuriken.add(
          await Flame.images.load('shuriken/shuriken' + i.toString() + '.png'));
    }
  }

  void draw(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, dimension.width, dimension.height),
        Paint()..color = Color(0xFFFFFFFF));

    // enemy
    for (int i = 0; i < obstacles.length; i++) {
      if (obstacles[i].obstacleState == ObstacleState.gone) {
        obstacles.removeAt(i);
      } else if (obstacles[i].obstacleState == ObstacleState.alive) {
        // fire
        if (obstacles[i].isFire()) {
          enemyBullets.add(obstacles[i].createBullet(imageShuriken));
        }
        obstacles[i].draw(canvas);
        obstacles[i].move();
      } else {
        obstacles[i].draw(canvas);
        obstacles[i].move();
      }
    }

    // bullet
    for (int i = 0; i < bullets.length; i++) {
      if (bullets[i].posObject.dy < -40 ||
          bullets[i].bulletState == BulletState.readyToDelete) {
        bullets.removeAt(i);
        i--;
      } else {
        bullets[i].draw(canvas);
        bullets[i].move();

        // check collision with crate
        if (checkCollisiontCrateBullet(listCrate, bullets[i]) &&
            bullets[i].bulletState == BulletState.flying) {
          bullets[i].bulletState = BulletState.stop;
        } else if (checkCollision(bullets[i]) ||
            checkCollisionShurikenEnemy(i, enemyBullets)) {
          // power bullet
          bullets.removeAt(i);
        }
      }
    }

    // crate
    for (Crate crate in listCrate) {
      crate.draw(canvas);
    }

    // enemy bullet
    for (int i = 0; i < enemyBullets.length; i++) {
      if (enemyBullets[i].posObject.dy < -40 ||
          enemyBullets[i].posObject.dy > dimension.height + 20) {
        enemyBullets.removeAt(i);
        i--;
      } else {
        enemyBullets[i].draw(canvas);
        enemyBullets[i].move();

//        if (checkCollision(bullets[i])) {
//          // power bullet
//          bullets.removeAt(i);
//        }
      }
    }

    player.draw(canvas);

    if (random.nextInt(100) % 70 == 0 && obstacles.length < 5) {
      obstacles.add(Obstacle.generateObstacle(
          obstacles,
          dimension.width,
          dimension.height,
          dimension.height - 400,
          40,
          50,
          50,
          1,
          100,
          imageExplosions,
          imageNinja));
    }

    if (listCrate.length < 4) {
      Crate crate = Crate.generateCrate(dimension.width, dimension.height, 40,
          dimension.height - 400, 50, 50, imgCrate);

      if (!checkCollisionCrates(listCrate, crate) && imgCrate != null) {
        listCrate.add(crate);
      }
    }
  }

  //check with crates
  bool checkCollisiontCrateBullet(List<Crate> list, Bullet bullet) {
    for (Crate crate in list) {
      if (GameUtil.check2RecOverlap(
          crate.pos.x,
          crate.pos.y,
          crate.width,
          crate.height,
          bullet.posObject.dx - bullet.radius,
          bullet.posObject.dy - bullet.radius,
          bullet.radius * 2,
          bullet.radius * 2)) {
        return true;
      }
    }
    return false;
  }

  bool checkCollisionCrates(List<Crate> list, Crate target) {
    for (Crate crate in list) {
      if (GameUtil.check2RecOverlap(
          crate.pos.x,
          crate.pos.y,
          crate.width,
          crate.height,
          target.pos.x,
          target.pos.y,
          target.width,
          target.height)) {
        return true;
      }
    }
    return false;
  }

  bool checkCollision(Bullet bullet) {
    for (int i = obstacles.length - 1; i >= 0; i--) {
      if (obstacles[i].checkCollision(bullet) &&
          obstacles[i].obstacleState == ObstacleState.alive) {
        obstacles[i].obstacleState = ObstacleState.explosion;
//        obstacles.removeAt(i);
        return true;
      }
    }
    return false;
  }

  bool checkCollisionShurikenEnemy(int bulletIndex, List<Bullet> eBullets) {
    for (int i = 0; i < eBullets.length; i++) {
      if (bullets[bulletIndex].checkCollisionBullet(eBullets[i])) {
//        bullets.removeAt(bulletIndex);
        eBullets.removeAt(i);
//        i--;
        return true;
      }
    }
    return false;
  }

  void drag(Offset offset) {
//    if (offset.dx >= player.posPlayer.dx - player.radius &&
//        offset.dx <= player.posPlayer.dx + player.radius &&
//        offset.dy >= player.posPlayer.dy - player.radius &&
//        offset.dy <= player.posPlayer.dy + player.radius) {
//      player.moveTo(Position(dx: offset.dx, dy: offset.dy));

    if (direction.length < 2) {
      direction.add(Position(dx: offset.dx, dy: offset.dy));
    } else {
      direction[1] = Position(dx: offset.dx, dy: offset.dy);
    }

    if (direction.length == 2) {
      player.moveTo(player.calculatePosInBoundary(direction[0], direction[1]));
    }
  }

  void dragEnd() {
    player.moveTo(Position(dx: dimension.width / 2, dy: dimension.height - 70));

    if (direction.length < 2) {
      return;
    }

    List<double> dir = List(2);

    dir[0] = direction[1].dx - direction[0].dx;
    dir[1] = direction[1].dy - direction[0].dy;

    Bullet bullet = Bullet(
        posObject: Position(dx: player.posPlayer.dx, dy: player.posPlayer.dy),
        speed: 0.1,
        radius: 15,
        direction: dir,
        bWidth: dimension.width,
        paint: paintBullet,
        imageShuriken: imageShuriken,
        bulletPlayer: BulletPlayer.player);

    bullets.add(bullet);

//    dir[0] = direction[1].dx - direction[0].dx - 20;
//    dir[1] = direction[1].dy - direction[0].dy;
//
//    Bullet bullet2 = Bullet(
//        posObject: Position(dx: dimension.width / 2, dy: dimension.height - 50),
//        speed: 0.1,
//        radius: 15,
//        direction: dir,
//        bWidth: dimension.width,
//        paint: paintBullet,
//        imageShuriken: imageShuriken[0],
//        bulletPlayer: BulletPlayer.player);
//
//    bullets.add(bullet2);
//
//    dir[0] = direction[1].dx - direction[0].dx + 20;
//    dir[1] = direction[1].dy - direction[0].dy;
//
//    Bullet bullet3 = Bullet(
//        posObject: Position(dx: dimension.width / 2, dy: dimension.height - 50),
//        speed: 0.1,
//        radius: 15,
//        direction: dir,
//        bWidth: dimension.width,
//        paint: paintBullet,
//        imageShuriken: imageShuriken[0],
//        bulletPlayer: BulletPlayer.player);
//
//    bullets.add(bullet3);

    if (bullets.length > 20) {
      bullets.removeRange(0, bullets.length - 20);
    }

    direction.clear();
  }
}
