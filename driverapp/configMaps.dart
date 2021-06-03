import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey ="AIzaSyBUD3W1dSc5goIkJCaqnbcg-Kbeo-PAZtc";
User? firebaseUser;

Users? userCurrentInfo;
User? currentfirebaseUser;
StreamSubscription<Position>? homeTabPageStreamSubscription;
