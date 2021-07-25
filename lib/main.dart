import 'package:discern/constants/route_constants.dart';
import 'package:discern/providers/auth_provider.dart';
import 'package:discern/router/route_generator.dart';
import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
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

  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()
        )
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    precacheImage(AssetImage('assets/imgs/battery.jpg'), context);
    precacheImage(AssetImage('assets/imgs/appliances.jpg'), context);
    precacheImage(AssetImage('assets/imgs/cleaning-product.jpg'), context);
    precacheImage(AssetImage('assets/imgs/computer.jpg'), context);
    precacheImage(AssetImage('assets/imgs/drugs.jpg'), context);
    precacheImage(AssetImage('assets/imgs/light-bulb.jpg'), context);
    precacheImage(AssetImage('assets/imgs/medical-waste.jpg'), context);
    precacheImage(AssetImage('assets/imgs/smartphone.jpg'), context);
    
    return MaterialApp(
      title: 'Discern',
      initialRoute: HomeViewRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
