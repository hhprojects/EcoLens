import 'package:eco_lens_draft/constants.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class DisplayPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  DisplayPage(this.cameras);

  @override
  _DisplayPageState createState() => new _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = ssd;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    String? res;
    res = await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");

    print(res);
  }

  setRecognitions(List<dynamic> recognitions, imageHeight, imageWidth) {
    print(recognitions);
    recognitions = recognitions.toList();
    recognitions.removeWhere((element) =>
        element["confidenceInClass"] < 0.6 ||
        element["detectedClass"] != "laptop" &&
            element["detectedClass"] != "cell phone");
    print(recognitions);
    // [{rect: {w: 0.9309328198432922, x: 0.009694457054138184, h: 0.6590256690979004, y: 0.214443176984787}, confidenceInClass: 0.71875, detectedClass: laptop}]
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Camera(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          BndBox(
            _recognitions == null ? [] : _recognitions!,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
            _model,
            onTap: (value) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Add to Home Devices"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Close"),
                      )
                    ],
                    content: Container(
                      height: 400,
                      child: Column(
                        children: [
                          Text("Product Information: $value"),
                          Text("Manufacturing Carbon Footprint: 300kg\n"),
                          Text("Recommended Products (Less Carbon Emission):"),
                          Card(
                            child: Text("acer-swift-14: ~200kg\n"),
                          ),
                          Text(
                              "Recommended Usage & Information: \n - A laptop that is on for eight hours (the average workday) a day dumps between 44 and 88 kgs of CO2e into the atmosphere each year. \n - Reduce Screen Brightness: Lower the screen brightness to save energy.\n - Unplug Chargers: Disconnect chargers when not actively charging to avoid unnecessary energy consumption."),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
