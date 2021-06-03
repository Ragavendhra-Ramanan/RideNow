
import 'package:driver_app/Notifications/notificationDalog.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService
{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future initialize(context) async {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      retrieveRideRequestInfo(message, context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      retrieveRideRequestInfo(message, context);
    });  }

  Future<void> getToken() async
  {
    String? token = await firebaseMessaging.getToken();
    print("This is token :: ");
    print(token);
    driversRef.child(currentfirebaseUser!.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("alldrivers");
    firebaseMessaging.subscribeToTopic("allusers");
  }
  void retrieveRideRequestInfo(RemoteMessage message, BuildContext context)
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => NotificationDialog(),
    );
  }
  }

