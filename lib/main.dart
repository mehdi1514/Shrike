import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/provider/image_upload_provider.dart';
import 'package:flutterapp/provider/user_provider.dart';
import 'package:flutterapp/resources/auth_methods.dart';
import 'package:flutterapp/screens/home_screen.dart';
import 'package:flutterapp/screens/login_screen.dart';
import 'package:flutterapp/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider(),),
        ChangeNotifierProvider(create: (_) => UserProvider(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        // Home1 - firestore
        // Home2 - firebase storage
        // Home3 - phone auth
        initialRoute: "/",
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
            if(snapshot.hasData){
              return HomeScreen();
            }else{
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}



