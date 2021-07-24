import 'package:discern/constants/route_constants.dart';
import 'package:discern/router/route_generator.dart';
import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tflite/tflite.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }

  await Tflite.loadModel(
    labels: 'assets/model/labels.txt',
    model: 'assets/model/model.tflite'
  );

  await dotenv.load(fileName: "assets/.env");

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
      initialRoute: HomeViewRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
