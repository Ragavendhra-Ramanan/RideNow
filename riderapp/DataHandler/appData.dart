import 'package:flutter/cupertino.dart';
import 'package:riders_app/Models/address.dart';
class AppData extends ChangeNotifier
{   Address? pickUpLocation=null;
Address?  dropOffLocation=null;
  void updatePickUpLocationAddress(Address pickUpAddress)
  {

    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
void updateDropOffLocationAddress(Address dropOffAddress)
{
  dropOffLocation = dropOffAddress;
  notifyListeners();
}

}