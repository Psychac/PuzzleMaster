import 'dart:io';

import 'package:flutter/material.dart';
import 'scan.dart';
import 'calibrate.dart';
import 'package:dio/dio.dart';
import 'solve.dart';
import 'package:path_provider/path_provider.dart';

class MagicCube extends StatefulWidget {
  @override
  _MagicCubeState createState() => _MagicCubeState();
}

class _MagicCubeState extends State<MagicCube> {
  final kButtonTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30.0,
    color: Colors.black87,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //     Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        child: SafeArea(
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Puzzle\nMaster",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 75.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: TextButton(
              //     onPressed: ()async{
              //       Directory tempDir = await getTemporaryDirectory();
              //       String dirPath = tempDir.path;
              //       Directory appDocDir = await getApplicationDocumentsDirectory();
              //       String appDocPath = appDocDir.path;
              //       String cubeString = "DFFUUDFBLBLLFRLBDURRUBFRRFUBLRUDRLFFBLDBLUFRDDULBBDRDU";
              //       Navigator.push(
              //           context, MaterialPageRoute(builder: (context) => SolveCube(cubeString: cubeString,path: appDocPath,)));
              //
              //     },
              //     child: Text("Solve module test"),
              //   ),
              // ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30.0,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CalibrateModule();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "CALIBRATE",
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          indent: MediaQuery.of(context).size.width / 2.7,
                          height: 5.0,
                          endIndent: MediaQuery.of(context).size.width / 2.7,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ScanModule();
                                    //return ScanCube();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "SCAN CUBE",
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          indent: MediaQuery.of(context).size.width / 2.7,
                          height: 5.0,
                          endIndent: MediaQuery.of(context).size.width / 2.7,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextButton(
                            onPressed: () async {
                              String resetUrl =
                                  "https://puzzlemaster.herokuapp.com/resetapp";
                              var dio = Dio();
                              dio.options.connectTimeout = 5000; //5s
                              var response = await dio.get(resetUrl);
                              print(response.data);
                            },
                            child: Text(
                              "RESET",
                              style: kButtonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
