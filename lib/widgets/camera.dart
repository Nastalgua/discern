import 'package:camera/camera.dart';
import 'package:discern/widgets/take_photo.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Camera({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _CameraState createState() => _CameraState();

  static bool isCameraLoaded() {
    return _CameraState.cameraLoaded;
  }
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initControllerFuture;

  static bool cameraLoaded = false;

  @override
  void initState() {
    super.initState();

    // ignore: unnecessary_null_comparison
    if (widget.cameras == null || widget.cameras.length < 1) {
      print("No camera found...");
    } else {
      _controller = new CameraController(
        widget.cameras[0], 
        ResolutionPreset.high
      );

      _initControllerFuture = _controller.initialize();
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black38,
          child: FutureBuilder(
            future: _initControllerFuture,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                cameraLoaded = true;
                return CameraPreview(_controller);
              } else {
                return const Center( // add timer, so some point can't find camera
                  child: CircularProgressIndicator()
                );
              }
            }
          ),
        ),
        FutureBuilder(
          future: _initControllerFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TakePhoto(cameraController: _controller);
            } else {
              return Container();
            }
          }
        )
      ]
    );
  }
}