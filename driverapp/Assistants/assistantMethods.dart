import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/Assistants/requestAssistant.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/Models/address.dart';
import 'package:driver_app/Models/allUsers.dart';
import 'package:driver_app/Models/directionDetails.dart';

import '../configMaps.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position,
      context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url ="https://eu1.locationiq.com/v1/reverse.php?key=pk.4dfd30e1160d656dd5752a788ecc119b&lat=${position.latitude}&lon=${position.longitude}&format=json ";

    var response = await RequestAssistant.getRequest(url);
   print(response);
    if (response != 'failed') {
      st1 = response["address"]["county"];
      st2=response["address"]["state_district"];
      placeAddress=st1+" "+st2;
      Address userPickUpAddress = new Address(placeName:"" , longitude:0, latitude: 0, placeId: '', placeFormattedAddress: '',);
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);


    }
    return placeAddress;
  }
  static  Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://us1.locationiq.com/v1/directions/driving/${initialPosition.latitude},${initialPosition.longitude};${finalPosition.latitude},${finalPosition.longitude}?key=pk.4dfd30e1160d656dd5752a788ecc119b&overview=full";

    var res = await RequestAssistant.getRequest(directionUrl);

    DirectionDetails directionDetails = DirectionDetails(durationValue: 0, distanceValue:0,);
    print("********************");
    print(res["routes"][0]["distance"]);
    directionDetails.distanceValue=11;
    directionDetails.durationValue =12;
return directionDetails;

  }
  static int calculateFares(DirectionDetails directionDetails)
  {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    double totalLocalAmount = totalFareAmount * 70;

    return totalLocalAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async
  {
    firebaseUser = FirebaseAuth.instance.currentUser;
    String userId = firebaseUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }
}