import 'package:driver_app/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/AllScreen/loginScreen.dart';
import 'package:driver_app/AllScreen/mainscreen.dart';
import 'package:driver_app/AllScreen/registerationScreen.dart';
import 'package:driver_app/DataHandler/appData.dart';

import 'AllScreen/carInfoScreen.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  currentfirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference? rideRequestRef = FirebaseDatabase.instance.reference().child("drivers").child(currentfirebaseUser!.uid).child("newRide");

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Ride Now',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        initialRoute:FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : MainScreen.idScreen,
        routes:
        {
          RegisterationScreen.idScreen: (context) => RegisterationScreen(),
          LoginScreen.idScreen: (context) => LoginScreen(),
          MainScreen.idScreen: (context) => MainScreen(),
          CarInfoScreen.idScreen: (context) => CarInfoScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

