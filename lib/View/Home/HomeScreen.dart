import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_ui/View/Login/login_screen.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
class HomeScreen extends StatelessWidget {
  final String providerId;
  const HomeScreen({Key key, this.providerId}) : super(key: key);

  Future<void> logout(BuildContext context) async{

    if(providerId == 'facebook.com'){

      FacebookLogin facebookLogin = FacebookLogin();
      await FirebaseAuth.instance.signOut().then(await (value) async {
        print("Sign Out Success");
        await  facebookLogin.logOut();
        await  FirebaseAuth.instance.signOut();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));});
      });

    }
    else if(providerId =='google.com'){

      final GoogleSignIn googleSignIn = GoogleSignIn();
      await FirebaseAuth.instance.signOut().then((value) async{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        await googleSignIn.disconnect();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));});
      });

    }
    else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));});

    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Center(
          child: FlatButton(
            color: Colors.blue,
            child: Text("Logout",style: TextStyle(
                color: Colors.white
            ),),
            onPressed:(){
              logout(context);
            },
          ),
        ),
      ),
    );
  }
}

