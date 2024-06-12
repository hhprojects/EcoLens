import 'dart:typed_data';

import 'package:eco_lens_draft/display_page.dart';
import 'package:eco_lens_draft/home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(MyApp(
    cameras: cameras,
  ));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(
        cameras: cameras,
      ),
    );
  }
}
