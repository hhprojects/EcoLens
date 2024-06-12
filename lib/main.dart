import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: ARDetectionScreen(camera: camera),
    );
  }
}

class ARDetectionScreen extends StatefulWidget {
  final CameraDescription camera;

  ARDetectionScreen({required this.camera});

  @override
  _ARDetectionScreenState createState() => _ARDetectionScreenState();
}

class _ARDetectionScreenState extends State<ARDetectionScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isDetecting = false;
  ArCoreController? arCoreController;
  List<dynamic>? _recognitions;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    loadModel();
  }

  @override
  void dispose() {
    _controller.dispose();
    arCoreController?.dispose();
    super.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/your_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AR Object Detection')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                if (_recognitions != null)
                  ..._recognitions!.map((recognition) {
                    final rect = Rect.fromLTRB(
                      recognition["rect"]["x"] * MediaQuery.of(context).size.width,
                      recognition["rect"]["y"] * MediaQuery.of(context).size.height,
                      recognition["rect"]["x"] + recognition["rect"]["w"] * MediaQuery.of(context).size.width,
                      recognition["rect"]["y"] + recognition["rect"]["h"] * MediaQuery.of(context).size.height,
                    );
                    return Positioned(
                      left: rect.left,
                      top: rect.top,
                      width: rect.width,
                      height: rect.height,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    );
                  }).toList()
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            if (!_isDetecting) {
              _isDetecting = true;
              _controller.startImageStream((CameraImage image) {
                if (_isDetecting) {
                  runModelOnFrame(image);
                }
              });
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  runModelOnFrame(CameraImage image) async {
    final List<dynamic>? recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: "YOLO",
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );

    setState(() {
      _recognitions = recognitions;
    });

    if (_recognitions != null && _recognitions!.isNotEmpty) {
      final recognition = _recognitions![0];
      final x = recognition["rect"]["x"] + recognition["rect"]["w"] / 2;
      final y = recognition["rect"]["y"] + recognition["rect"]["h"] / 2;

      placeARObject(x, y);
    }

    _isDetecting = false;
  }

  void placeARObject(double x, double y) async {
    final centerX = x / _controller.value.previewSize!.width;
    final centerY = y / _controller.value.previewSize!.height;

    final centerVector = vector.Vector3(centerX, centerY, -1.0);

    final node = ArCoreNode(
      shape: ArCoreSphere(materials: [
        ArCoreMaterial(color: Colors.blue),
      ]),
      position: centerVector,
    );

    arCoreController?.addArCoreNode(node);
  }
}