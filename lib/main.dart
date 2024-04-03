import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo16_fairbace/pages/detail_page.dart';
import 'package:ngdemo16_fairbace/pages/home_page.dart';
import 'package:ngdemo16_fairbace/pages/signin_page.dart';
import 'package:ngdemo16_fairbace/pages/signup_page.dart';
import 'package:ngdemo16_fairbace/services/prefs_service.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget _startPage() {
    // return StreamBuilder<User>(
    //   stream: FirebaseAuth.instance.onAuthStateChanged,
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.hasData) {
    //       Prefs.saveUserId(snapshot.data!.uid);
    //       return HomePage();
    //     } else {
    //       Prefs.removeUserId();
    //       return SignInPage();
    //     }
    //   },
    // );
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Prefs.saveUserId(snapshot.data!.uid);
          return HomePage();
        } else {
          Prefs.removeUserId();
          return SignInPage();
        }
      },
    );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _startPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        SignInPage.id: (context) => SignInPage(),
        SignUpPage.id: (context) => SignUpPage(),
        DetailPage.id: (context) => DetailPage(),
      },
    );
  }
}

