import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:shuriken/game.dart';

class ShurikenWidget extends BaseGame {
  final Size dimension;
  Shuriken game;

  ShurikenWidget(this.dimension) {
    game = Shuriken(dimension);
  }

  @override
  void update(double t) {}

  @override
  void render(Canvas canvas) {
    game.draw(canvas);
  }

  void tapMove(Offset offset) {
    print('tapMove');
    game.drag(offset);
  }

  void dragEnd(DragEndDetails dragEndDetails) {
    print('dragEnd');
    game.dragEnd();
  }
}
