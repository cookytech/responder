import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responder/responder.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer timer;
  int i = 0;

  startCounting() {
    i = 0;
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        i = timer.tick;
      });
      if (i == 100) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responder(
        builder: (context) {
          if (i % 10 == 0) {
            return null;
          } else
            return WidgetBody(number: i);
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: startCounting),
    );
  }
}

class WidgetBody extends StatelessWidget {
  final int number;

  const WidgetBody({Key key, @required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(number.toString()));
  }
}
