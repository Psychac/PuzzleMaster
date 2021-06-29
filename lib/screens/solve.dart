import 'package:flutter/material.dart';
import 'package:puzzle_master/state/data_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cuber/cuber.dart';
import 'package:dio/dio.dart';

// class SolveCube extends StatefulWidget {
//   SolveCube({this.cubeString});
//
//   final String cubeString;
//
//   @override
//   _SolveCubeState createState() => _SolveCubeState();
// }
//
// class _SolveCubeState extends State<SolveCube> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }



class SolveCube extends StatefulWidget {
  SolveCube({this.cubeString});
  final String cubeString;
  @override
  _SolveCubeState createState() => _SolveCubeState();
}

class _SolveCubeState extends State<SolveCube> {
  Cube cube;
  Solution solution;
  var rotations;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cube = Cube.from(widget.cubeString);
    solution = cube.solve(maxDepth: 25, timeout: Duration(minutes: 1));
    rotations = solution.algorithm.moves;
    print(rotations);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataState>(builder: (context, child, model) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Rotations"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // initalView(),
                // Divider(
                //   height: 3,
                //   color: Colors.black,
                // ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: rotations.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                        height: 3,
                        color: Colors.black,
                      ),
                  itemBuilder: (BuildContext context, int index) {
                    return rotation(index, rotations[index]);
                  },
                )
              ],
            ),
          ));
    });
  }

  Widget initalView() {
    return Container(
      height: 320,
      color: Colors.grey[300],
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "*2 - Turn two times",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              )),
          Text(
            "Inital View",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          Image.asset(
            "assets/initial.png",
            height: 250,
          )
        ],
      ),
    );
  }

  Widget rotation(index, turn) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Step $index: $turn",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          Image.asset(
            "assets/$turn.png",
            height: 220,
          )
        ],
      ),
    );
  }
}
