import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:discern/widgets/camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Home({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('GitHub'),
            ),
            ListTile(
              title: Text('Sign Out'),
            )
          ],
        ),
      )
    );
  }

  Widget _buildIcon(BuildContext context, String iconPath, double iconSize, Function onPressed) {
    return IconButton(
      iconSize: iconSize,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: SvgPicture.asset(iconPath),
      onPressed: () { onPressed(); },
    );
  }

  Widget _buildUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIcon(
                context, 
                'assets/icons/hamburger-menu.svg', 
                20.0, 
                () => _scaffoldKey.currentState!.openDrawer()
              ),
              _buildIcon(
                context, 
                'assets/icons/inventory.svg', 
                48.0, 
                () {}
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Camera(cameras: widget.cameras),
          _buildUI(context)
        ],
      ),
    );
  }
}
