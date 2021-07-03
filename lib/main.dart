import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/Home/HomeScreen.dart';
import 'View/Login/login_screen.dart';

Future<void> main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
	runApp(
			MaterialApp(
				debugShowCheckedModeBanner: false,
				home: MainApp(),
			)
	);
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
	bool isUserLogin = false;
	String social="";

	Future<void> isLogin() async {
		FirebaseAuth firebaseAuth = FirebaseAuth.instance;
		User user = await firebaseAuth.currentUser;
		if(user == null){
			setState(() {
				isUserLogin= false;
			});
		}
		else{
			setState(() {
				social = user.providerData[0].providerId;
				isUserLogin= true;
			});
		}

	}

	@override
  void initState() {
    // TODO: implement initState
		WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
			await isLogin();
		});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isUserLogin?HomeScreen(
				providerId: social,
			):LoginScreen()
    );
  }


}