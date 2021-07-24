import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:discern/ui/home.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Discern',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(cameras: cameras)
    );
  }
}
