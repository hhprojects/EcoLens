import 'dart:typed_data';

import 'package:eco_lens_draft/camera.dart';
import 'package:eco_lens_draft/home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(
    camera: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> camera;
  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(camera),
    );
  }
}
