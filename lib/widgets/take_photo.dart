import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TakePhoto extends StatefulWidget {
  final CameraController cameraController;

  TakePhoto({
    Key? key, 
    required this.cameraController
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> with SingleTickerProviderStateMixin {
  bool _takingPhoto = false;
  bool _visible = true;

  @override
  void initState() { 
    super.initState();
  }

  @override
  void dispose() { 
    super.dispose();
  }

  Future<void> changeColors() async {
    setState(() {
      _visible = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _takingPhoto = !_takingPhoto;
        _visible = true;
      });
    });
  }

  Future<void> takePhoto() async {
    try {      
      final image = await widget.cameraController.takePicture();

      print(image);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: GestureDetector(
          onTapDown: (details) async { // make button fade into another color
            this.changeColors();
            this.takePhoto();
          },
          onTapUp: (details) async {
            await Future<void>.delayed(const Duration(milliseconds: 800), () {
              this.changeColors();
            });
          },
          child: _takingPhoto ?
            AnimatedOpacity( // red
              opacity: _visible ? 1.0 : 0,
              duration: Duration(milliseconds: 200),
              child: SvgPicture.asset(
                'assets/icons/take-photo.svg',
                width: 57.0,
                height: 57.0,
                color: Colors.red,
              ),
            ) :
            AnimatedOpacity( // white
              opacity: _visible ? 1.0 : 0,
              duration: Duration(milliseconds: 200),
              child: SvgPicture.asset(
                'assets/icons/take-photo.svg',
                width: 57.0,
                height: 57.0,
                color: Colors.white,
              ),
            )
          )
      ),
    );
  }
}