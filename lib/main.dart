import 'package:flutter/material.dart';
import 'package:puzzle_master/screens/magic_cube.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:puzzle_master/state/data_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: DataState(),
        child: MaterialApp(
          title: 'Flutter Demo',
          home: MagicCube(),
        ));
  }
}
