import 'package:flutter/material.dart';

import 'package:discern/constants/route_constants.dart';
import 'package:discern/providers/auth_provider.dart';
import 'package:discern/helpers/font_text.dart';
import 'package:discern/widgets/camera/camera.dart';

import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildUserInfo(BuildContext context) {
    return Consumer(
      builder: (context, AuthProvider auth, child) {
        return AuthProvider.isLoggedIn() ?
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(AuthProvider.getUser().photoURL!),
                ),
              ),
              poppinsText(AuthProvider.getUser().displayName!, 18, FontWeight.w600),
              poppinsText(AuthProvider.getUser().email!, 11, FontWeight.w300),
              Divider(height: 30)
            ],
          ),
        )
        : ListTile(
          leading: SvgPicture.asset('assets/icons/drawer/user.svg', width: 25, height: 25),
          title: poppinsText('Sign In', 14, FontWeight.w400),
          onTap: () async {
            await auth.googleLogin();
          },
        );
      }
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: ListView(
          children: [
            this._buildUserInfo(context),
            ListTile(
              leading: SvgPicture.asset('assets/icons/drawer/github.svg', width: 25, height: 25),
              title: poppinsText('GitHub', 14, FontWeight.w400),
              onTap: () async {
                String url = "https://github.com/Nastalgua/discern";
                await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
              }
            ),
            Consumer(
              builder: (context, AuthProvider auth, child) {
                return AuthProvider.isLoggedIn() ? 
                ListTile(
                  leading: Icon(Icons.logout, size: 25, color: Colors.black),
                  title: poppinsText('Sign Out', 14, FontWeight.w400),
                  onTap: () async {
                    await auth.googleLogout();
                  },
                )
                : Container();
              }
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
                () => scaffoldKey.currentState!.openDrawer()
              ),
              _buildIcon(
                context, 
                'assets/icons/inventory.svg', 
                48.0, 
                () {
                  if (!AuthProvider.isLoggedIn()) {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => failAlert(context)
                    );

                    return;
                  }
                  
                  Navigator.of(context).pushNamed(InventoryViewRoute);
                }
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
      key: scaffoldKey,
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
