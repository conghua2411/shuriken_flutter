import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuriken/gameScreen.dart';

void main() async {
  await Flame.util.fullScreen();
  await Flame.util.setOrientation(DeviceOrientation.portraitUp);
  Size dimension = await Flame.util.initialDimensions();

//  runApp(
//      MaterialApp(
//        home: GameScreen(dimension),
//      )
//  );

  runApp(MaterialApp(
    home: HomeScreen(dimension: dimension),
  ));
}

class HomeScreen extends StatelessWidget {
  final Size dimension;

  HomeScreen({this.dimension});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'shuriken',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                child: Text('start'),
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameScreen(dimension)));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
