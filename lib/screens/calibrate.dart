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

class CalibrateModule extends StatefulWidget {
  @override
  _CalibrateModuleState createState() => _CalibrateModuleState();
}

class _CalibrateModuleState extends State<CalibrateModule> {
  Map colorToColorCodeMapping = {
    "Green": null,
    "Red": null,
    "Blue": null,
    "Orange": null,
    "White": null,
    "Yellow": null,
  };
  Map colorToRGBMapping = {
    "Green": null,
    "Red": null,
    "Blue": null,
    "Orange": null,
    "White": null,
    "Yellow": null,
  };

  Color savedColor;
  String selectedColorName = "Green";
  String selectedSideName = "F";
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
        elevation: 0.0,
        leading: IconButton(
          color: Colors.black87,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Center(
          child: Text(
            "CALIBRATE COLORS",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
              onPressed: () async {
                String serverUrl =
                    "https://puzzlemaster.herokuapp.com/calibratePallete";
                //String serverUrl = "http://192.168.43.133:5000/calibratePallete";
                var dio = Dio();
                dio.options.connectTimeout = 5000; //5s

                const JsonCodec json = JsonCodec();
                var colorsToRGBJson = json.encode({
                  "Green": colorToRGBMapping["Green"],
                  "Red": colorToRGBMapping["Red"],
                  "Blue": colorToRGBMapping["Blue"],
                  "Orange": colorToRGBMapping["Orange"],
                  "White": colorToRGBMapping["White"],
                  "Yellow": colorToRGBMapping["Yellow"],
                });

                FormData formData = FormData.fromMap({
                  "colors": colorsToRGBJson,
                });

                try {
                  var response = await dio.post(serverUrl, data: formData);
                  // print(response.statusCode);
                  print(response.data);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: (response.data['status'] == true)
                          ? Text(
                              response.data['msg'],
                            )
                          : Text(
                              response.data['msg'],
                            ),
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
                                  return ScanModule();
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
                      content: Text(
                        "Server error",
                      ),
                      action: SnackBarAction(
                        label: "Try again",
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          initialData: Colors.transparent,
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = snapshot.data ?? Colors.white70;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RepaintBoundary(
                      key: paintKey,
                      child: GestureDetector(
                        onPanDown: (details) {
                          searchPixel(details.globalPosition);
                        },
                        onPanUpdate: (details) {
                          searchPixel(details.globalPosition);
                        },
                        child: (imagePath == null)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50.0,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Image will go here",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              )
                            : Image(
                                image: FileImage(File(imagePath)),
                                key: imageKey,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Choose color:",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        DropdownButton(
                            value: selectedColorName,
                            icon: Icon(Icons.arrow_drop_down),
                            items: [
                              DropdownMenuItem(
                                  child: Text(
                                    "Green",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "Green"),
                              DropdownMenuItem(
                                  child: Text(
                                    "Red",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "Red"),
                              DropdownMenuItem(
                                  child: Text(
                                    "Blue",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "Blue"),
                              DropdownMenuItem(
                                  child: Text(
                                    "Orange",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "Orange"),
                              DropdownMenuItem(
                                  child: Text(
                                    "White",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "White"),
                              DropdownMenuItem(
                                  child: Text(
                                    "Yellow",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  value: "Yellow"),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedColorName = value;
                                currentColor = selectedColorName;
                              });
                            }),
                        Container(
                          decoration: BoxDecoration(
                            color: colorToColorCodeMapping[currentColor] == null
                                ? Colors.black26
                                : Color(colorToColorCodeMapping[currentColor]),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          height: 50.0,
                          width: 50.0,
                        ),
                        // SizedBox(
                        //   width: 20.0,
                        // ),
                        Text(
                          colorToColorCodeMapping[currentColor] == null
                              ? "Color not calibrated"
                              : "Color calibrated",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        Icon(colorToColorCodeMapping[currentColor] == null
                            ? Icons.warning
                            : Icons.check),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          savedColor = selectedColor;
                          colorToColorCodeMapping[currentColor] =
                              savedColor.value;
                          int blue = savedColor.blue;
                          int red = savedColor.red;
                          int green = savedColor.green;
                          colorToRGBMapping[currentColor] = [red, green, blue];
                          print(colorToRGBMapping);
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          borderRadius:
                              const BorderRadius.all(const Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text('Save Color',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  backgroundColor: Colors.black54)),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      top: 8.0,
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: OutlinedButton(
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
                      child: Center(
                        child: Text(
                          "Change photo",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 17.0,
                          ),
                        ),
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
