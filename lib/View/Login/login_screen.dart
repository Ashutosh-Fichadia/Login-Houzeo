import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_ui/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_ui/View/Home/HomeScreen.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:login_ui/View/Login/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../size_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String phone;
  String password;
  bool isMatched;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> handleLogin() async {

    final FacebookLoginResult result = await facebookLogin.logIn(['email']);


    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          print("in try");
          await loginWithfacebook(result);

          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(text: 'facebook',)));
        } catch (e) {
          print(e);
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {

    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
    FacebookAuthProvider.credential(accessToken.token);
    User user = (await firebaseAuth.signInWithCredential(credential)).user;

    if(user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(providerId: "facebook.com",))).then((value) {
        print("Navigated");
      });
    }

  }
  void getData(String phone, String password){
    bool isMatched = false;
    print("Phone = " + phone);
    print("Pass = " + password);
    final userRef = FirebaseFirestore.instance.collection('users');
    userRef.get().then((snapshot) {

      print("Phone = " + snapshot.docs[0].data()['phone']);
      print("Pass = " + snapshot.docs[0].data()['password']);
      for(int i =0;i<snapshot.docs.length;i++){

        if(snapshot.docs[i].data()['phone'] == phone && snapshot.docs[i].data()['password'] == password)
        {
          setState(() {
            isMatched = true;
          });
          print("succesfull login with phone");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(providerId: 'phone',)));
          break;
        }
        else{
          print("In Else");
        }


      }

      if(!isMatched){
        print("insuccessfull login");
        Fluttertoast.showToast(
            msg: "Invalid phone number or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print("invalid");
      }
    }

    );

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(1, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(1.5, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeAnimation(1.6, Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1.8, Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10)
                            )
                          ]
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: buildPhoneField()
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: buildPassField()
                            ),

                            GestureDetector(
                              onTap: (){
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  // if all r valid then go to success screen

                                  print("success");
                                  getData(phone.trim(), password.trim());
                                  //   loginWithEmailPassword(email.trim(), password.trim());

                                }
                              },
                              child: FadeAnimation(2, Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ]
                                    )
                                ),
                                child: Center(
                                  child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )),
                            ),
                            SizedBox(
                              height: 40,
                              child: Error(
                                errors: errors,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                    SizedBox(height: 20,),
                    FadeAnimation(1.5, Text("or Continue with"),),
                    SizedBox(height: 20,),
                    FadeAnimation(1.5, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap:(){
                            print("Google");
                            _signInWithGoogle(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(143, 148, 251, .4),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: SvgPicture.asset("assets/images/google-icon.svg"),
                          ),
                        ),
                        SizedBox(width: 40,),
                        InkWell(
                          onTap: () async{
                            print("Facebook");
                            await handleLogin();
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(143, 148, 251, .4),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: SvgPicture.asset("assets/images/facebook-2.svg"),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _signInWithGoogle(BuildContext context) async{
    googleSignIn.disconnect();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken , accessToken: googleAuth.accessToken );
    final User user = (await firebaseAuth.signInWithCredential(credential)).user;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(providerId: "google.com",)));
    // Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
  }
  TextFormField buildPhoneField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        } else if (phoneValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidPhoneError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        } else if (!phoneValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidPhoneError);
          return "";
        }
        return null;
      },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Phone number",
            hintStyle: TextStyle(color: Colors.grey[400])
        ),
    );
  }

  TextFormField buildPassField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.grey[400])
      ),
    );
  }
}
