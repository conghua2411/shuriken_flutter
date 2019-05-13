import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:shuriken/gameScreen.dart';

void main() async {
  await Flame.util.fullScreen();
  Size dimension = await Flame.util.initialDimensions();

  runApp(
      MaterialApp(
        home: GameScreen(dimension),
      )
  );
}
