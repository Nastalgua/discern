
import 'package:discern/widgets/font_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget failAlert(BuildContext context) {
  return AlertDialog(
    title: poppinsText(
      'Not logged in?', 
      20, 
      FontWeight.w600
    ),
    content: poppinsText(
      'You can do so in the sidebar.', 
      15, 
      FontWeight.normal
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, 'OK'),
        child: poppinsText('OK', 15, FontWeight.normal)
      )
    ],
  );
}

class AuthProvider with ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  static CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> googleLogin() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    final res = await FirebaseAuth.instance.signInWithCredential(credential);

    if (res.additionalUserInfo!.isNewUser) {
      await users.doc(res.user?.uid).set({
        'id' : res.user?.uid,
        'inventory' : []
      });
    }

    notifyListeners();
  }

  Future<void> googleLogout() async {
    await FirebaseAuth.instance.signOut();

    notifyListeners();
  }

  static User getUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

}
