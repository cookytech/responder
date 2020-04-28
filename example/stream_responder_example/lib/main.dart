import 'package:flutter/material.dart';
import 'package:responder/responder.dart';
import 'package:streamresponderexample/number_stream.dart';

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
  NumberStream numberStream = NumberStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamResponder(
        initialData: 1,
        stream: numberStream.numbers,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data % 12 == 0) {
            numberStream.cancel();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: Center(
                    child: Text(snapshot.data.toString()),
                  ),
                ),
              ),
            );
            return null;
          }
          return Center(child: Text(snapshot.data.toString()));
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        numberStream.init();
      }),
    );
  }
}
