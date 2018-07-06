import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  final Random _random = Random();
  Color color = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return ColorState(
      color: color,
      onTap: onTap,
      child: BoxTree(),
    );
  }

  // custom onTap function that can state, color
  void onTap() {
    setState(() {
      color = Color.fromRGBO(
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextDouble(),
      );
    });
  }
}

// This is where the magic happens
class ColorState extends InheritedWidget {
  // the info we need to pass around
  final Color color;
  // the function changes state, and allows the stateless widgets that inherit this, change state
  final Function onTap;

  // const for performance gains
  const ColorState({
    Key key,
    this.color,
    this.onTap,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ColorState oldWidget) {
    return color != oldWidget.color;
  }

  static ColorState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ColorState);
  }
}

// The widget tree used to demonstrate inherited widget
class BoxTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            children: <Widget>[
              // two boxes, and when changes are made to either one, they are reflected on  both
              Box(),
              Box(),
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorState = ColorState.of(context);

    return GestureDetector(
      onTap: colorState.onTap,
      child: Container(
        width: 50.0,
        height:50.0,
        margin: EdgeInsets.only(left: 100.0),
        color: colorState.color,
      ),
    );
  }
}