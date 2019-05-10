import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shuriken/gameWidget.dart';

class GameScreen extends StatefulWidget {
  final Size dimension;

  GameScreen(this.dimension);

  @override
  State createState() => GameState();
}

class GameState extends State<GameScreen> {
  var gameWidget;

  @override
  void initState() {
    super.initState();
    gameWidget = ShurikenWidget(widget.dimension);

    HorizontalDragGestureRecognizer horizontalDragGestureRecognizer =
        HorizontalDragGestureRecognizer();

    horizontalDragGestureRecognizer.onUpdate =
        (startDetails) => gameWidget.tapMove(startDetails.globalPosition);
    horizontalDragGestureRecognizer.onEnd =
        (dragEndDetails) => gameWidget.dragEnd(dragEndDetails);

    Flame.util.addGestureRecognizer(horizontalDragGestureRecognizer);
  }

  @override
  Widget build(BuildContext context) {
    return gameWidget.widget;
  }
}
