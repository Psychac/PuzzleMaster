//////////////////////////////
//
// 2019, roipeker.com
// screencast - demo simple image:
// https://youtu.be/EJyRH4_pY8I
//
// screencast - demo snapshot:
// https://youtu.be/-LxPcL7T61E
//
//////////////////////////////
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:puzzle_master/screens/scan.dart';
import 'dart:convert';

class ColorPickerWidget extends StatefulWidget {
  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  var serverUrl = "http://192.168.43.133:8000/calibratePallete";

  Map colorPalette = {
    "Green": null,
    "Red": null,
    "Blue": null,
    "Orange": null,
    "White": null,
    "Yellow": null,
  };
  Map newPalette = {
    "Green": null,
    "Red": null,
    "Blue": null,
    "Orange": null,
    "White": null,
    "Yellow": null,
  };
  Map sideNotation = {
    "F": null,
    "R": null,
    "B": null,
    "L": null,
    "U": null,
    "D": null,
  };
  Color savedColor;
  String _value = "Green";
  String _valueSide = "F";
  String currentColor;
  String currentSide;
  String imagePath;
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

  // CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

  // based on useSnapshot=true ? paintKey : imageKey ;
  // this key is used in this example to keep the code shorter.
  GlobalKey currentKey;

  final StreamController<Color> _stateController = StreamController<Color>();
  img.Image photo;

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = useSnapshot ? "snapshot" : "basic";
    return Scaffold(
      appBar: AppBar(
        title: Text("Color picker $title"),
        actions: [
          TextButton(
            onPressed: () async {
              String serverUrl = "http://192.168.43.133:8000/calibratePallete";
              var dio = Dio();
              dio.options.connectTimeout = 5000; //5s

              const JsonCodec json = JsonCodec();
              var jsonFile = json.encode({
                "Green": newPalette["Green"],
                "Red": newPalette["Red"],
                "Blue": newPalette["Blue"],
                "Orange": newPalette["Orange"],
                "White": newPalette["White"],
                "Yellow": newPalette["Yellow"],
              });
              var sideName = json.encode({
                "F": sideNotation["F"],
                "R": sideNotation["R"],
                "B": sideNotation["B"],
                "L": sideNotation["L"],
                "U": sideNotation["U"],
                "D": sideNotation["D"],
              });
              print(sideName);
              FormData formData = FormData.fromMap({
                "colors" : jsonFile,
                "side" : sideName,
              });


              try {
                var response = await dio.post(serverUrl, data: formData);
                // print(response.statusCode);
                 print(response.data);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: (response.data['status'] == true)
                        ? Text(response.data['msg'])
                        : Text(response.data['msg']),
                    action: SnackBarAction(
                      label: (response.data['status'] == true)
                          ? 'Done'
                          : 'Try again',
                      onPressed: () {
                        if (response.data['status'] == true) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage();
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Server error"),
                    action: SnackBarAction(
                      label: "Try again",
                      onPressed: () {},
                    ),
                  ),
                );
              }
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = snapshot.data ?? Colors.green;
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: RepaintBoundary(
                    key: paintKey,
                    child: GestureDetector(
                      onPanDown: (details) {
                        searchPixel(details.globalPosition);
                      },
                      onPanUpdate: (details) {
                        searchPixel(details.globalPosition);
                      },
                      child: Center(
                        child: (imagePath == null)
                            ? Center(
                                child: Text("Image will go here"),
                              )
                            : Image(
                                image: FileImage(File(imagePath)),
                                key: imageKey,
                                fit: BoxFit.contain,
                              ),
                        // child: Image.asset(
                        //   imagePath,
                        //   key: imageKey,
                        //   fit: BoxFit.contain,
                        // ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                            value: _value,
                            icon: Icon(Icons.arrow_drop_down),
                            items: [
                              DropdownMenuItem(
                                  child: Text("Green"), value: "Green"),
                              DropdownMenuItem(
                                  child: Text("Red"), value: "Red"),
                              DropdownMenuItem(
                                  child: Text("Blue"), value: "Blue"),
                              DropdownMenuItem(
                                  child: Text("Orange"), value: "Orange"),
                              DropdownMenuItem(
                                  child: Text("White"), value: "White"),
                              DropdownMenuItem(
                                  child: Text("Yellow"), value: "Yellow"),
                            ],
                            onChanged: (value) {
                              //print(value);
                              //print(colorPalette);
                              setState(() {
                                _value = value;
                                currentColor = _value;
                              });
                            }),
                        DropdownButton(
                            value: _valueSide,
                            icon: Icon(Icons.arrow_drop_down),
                            items: [
                              DropdownMenuItem(
                                  child: Text("Front"), value: "F"),
                              DropdownMenuItem(
                                  child: Text("Right"), value: "R"),
                              DropdownMenuItem(
                                  child: Text("Back"), value: "B"),
                              DropdownMenuItem(
                                  child: Text("Left"), value: "L"),
                              DropdownMenuItem(
                                  child: Text("Up"), value: "U"),
                              DropdownMenuItem(
                                  child: Text("Down"), value: "D"),
                            ],
                            onChanged: (value) {
                              //print(value);
                              //print(colorPalette);
                              setState(() {
                                _valueSide = value;
                                currentSide = _valueSide;
                              });
                            }),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50.0,
                                width: 50.0,
                                color: colorPalette[currentColor] == null
                                    ? Colors.black26
                                    : Color(colorPalette[currentColor]),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(colorPalette[currentColor] == null
                                  ? "Color not calibrated"
                                  : "Color calibrated"),
                              Icon(colorPalette[currentColor] == null
                                  ? Icons.warning
                                  : Icons.check),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        savedColor = selectedColor;
                        colorPalette[currentColor] = savedColor.value;
                        int blue = savedColor.blue;
                        int red = savedColor.red;
                        int green = savedColor.green;
                        newPalette[currentColor] = [red,green,blue];
                        sideNotation[currentSide] = currentColor;
                        print(newPalette);
                        print(sideNotation);

                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: selectedColor,
                      ),
                      child: Center(
                        child: Text('Save Color',
                            style: TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.black54)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      ImagePicker _picker = ImagePicker();
                      final pickedFile =
                          await _picker.getImage(source: ImageSource.camera);
                      setState(() {
                        imagePath = pickedFile.path;
                        //imagePath = "assets/8991.jpg";
                        photo = null;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: Text("Change photo"),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo.width;
      print(py);
      px = (px / widgetScale);
      py = (py / widgetScale);
    }

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
