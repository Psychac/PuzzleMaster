import 'package:flutter/material.dart';
import 'scan.dart';
import 'calibrate.dart';
import 'package:dio/dio.dart';

class MagicCube extends StatefulWidget {
  @override
  _MagicCubeState createState() => _MagicCubeState();
}

class _MagicCubeState extends State<MagicCube> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PuzzleMaster"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ColorPickerWidget();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Calibrate colors',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                      subtitle: Text('Calibrate the colors of the solver according to your cube for accurate results.',style: TextStyle(fontSize: 20.0,),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.0,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomePage();
                            //return ScanCube();
                          },
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Scan cube',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                      subtitle: Text('Scan the cube and get the solution.',style: TextStyle(fontSize: 20.0,),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.0,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    onTap: ()async{
                      String resetUrl = "http://192.168.43.133:8000/resetapp";
                      var dio = Dio();
                      dio.options.connectTimeout = 5000; //5s
                      var responser = await dio.get(resetUrl);
                      // print(response.statusCode);
                      print(responser.data);
                    },
                    child: ListTile(
                      title: Text('Reset',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
                      subtitle: Text('Reset the configurations in case there are any errors.',style: TextStyle(fontSize: 20.0,),),
                    ),
                  ),
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return ColorPickerWidget();
              //         },
              //       ),
              //     );
              //   },
              //   child: Text("calibrate"),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return HomePage();
              //           //return ScanCube();
              //         },
              //       ),
              //     );
              //   },
              //   child: Text("scan"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
