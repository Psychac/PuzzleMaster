import 'package:flutter/material.dart';
import 'package:flutter_svg/parser.dart';
import 'package:puzzle_master/state/data_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cuber/cuber.dart';
import 'dart:io';


class SolveCube extends StatefulWidget {
  SolveCube({this.cubeString,this.path});
  final String cubeString;
  final String path;
  @override
  _SolveCubeState createState() => _SolveCubeState();
}

class _SolveCubeState extends State<SolveCube> {
  Cube cube;
  Solution solution;
  var rotations;
  String dirPath;
  String svg;

  Move getMove(Move move) {
    var newMove = move.toString();
    return Move.parse(newMove);
  }

  @override
  void initState() {
    super.initState();

    cube = Cube.from(widget.cubeString);
    solution = cube.solve();
    rotations = solution.algorithm.moves;
    print(rotations);


    // svg = cube.svg();
    // dirPath = widget.path;
    // File(dirPath+'/cuber.svg').writeAsStringSync(svg);
    // final SvgParser parser = SvgParser();
    // try {
    //   parser.parse(svg, warningsAsErrors: true);
    //   print('SVG is supported');
    // } catch (e) {
    //   print('SVG contains unsupported features');
    // }


    // var cubeString = cube;
    // var counter = 0;
    // for (final move in rotations) {
    //   cubeString = cubeString.move(getMove(move));
    //   final svg = cubeString.svg();
    //   File(dirPath+'/cuber_move$counter.svg').writeAsStringSync(svg);
    //   counter++;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DataState>(builder: (context, child, model) {
      return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              color: Colors.black87,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "SOLUTION",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: initalView(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Divider(
                      //indent: MediaQuery.of(context).size.width / 10,
                      height: 5.0,
                      //endIndent: MediaQuery.of(context).size.width / 10,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: rotations.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Divider(
                              height: 3,
                              color: Colors.black,
                            ),
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        return rotation(index, rotations[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          ));
    });
  }

  Widget initalView() {
    return Container(
      //height: 320,
      color: Colors.white,
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
            "Initial View",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 12,
          ),
          //ScalableImageWidget.fromSISource(si: ScalableImageSource.f),
          //Container(child: SvgPicture.string(svg,height: 400.0,width: 400.0,),),
          //Image.file(File(dirPath+"/cuber.svg"),fit: BoxFit.contain,),
          //SvgPicture.asset("assets/cuber.svg",)
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
      //height: 300,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Step ${index+1}: $turn",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Image.asset(
            "assets/$turn.png",
            height: 220,
          ),
          //SvgPicture.asset(dirPath+'/cuber_move$index.svg',fit: BoxFit.contain,),
        ],
      ),
    );
  }
}
