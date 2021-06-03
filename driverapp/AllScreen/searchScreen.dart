
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_app/AllWidgets/divideWidget.dart';
import 'package:driver_app/AllWidgets/progressDialog.dart';
import 'package:driver_app/Assistants/assistantMethods.dart';
import 'package:driver_app/Assistants/requestAssistant.dart';
import 'package:driver_app/DataHandler/appData.dart';
import 'package:driver_app/Models/address.dart';
import 'package:driver_app/Models/placePredictions.dart';
import 'package:driver_app/configMaps.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context)
  {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation!.placeName;
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [

                  SizedBox(height: 25.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                            Icons.arrow_back
                        ),
                      ),

                      Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),

                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "PickUp Location",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[200],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          //tile for predictions
          SizedBox(height: 10.0,),
          (placePredictionList.length > 0)
              ? Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.separated(
                padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index)
                {
                  return PredictionTile(placePredictions: placePredictionList[index],);
                },
                separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                itemCount: placePredictionList.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://api.locationiq.com/v1/autocomplete.php?key=pk.4dfd30e1160d656dd5752a788ecc119b&q=$placeName&countrycodes=in";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed")
      {
        return;
      }

      else
      {
        print(res);
        var predictions = res;

        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}


class PredictionTile extends StatelessWidget
{
  final PlacePredictions placePredictions;

  PredictionTile({Key ?key,required this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: ()
      {
        getPlaceAddressDetails(placePredictions.place_id,placePredictions.main_text,placePredictions.lats,placePredictions.longs, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0,),
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId,String main_text,double lats, double longs, context) async
  {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Setting Dropoff, Please wait...",)
    );


    Navigator.pop(context);


      Address address =  new Address(placeName:"" , longitude:0, latitude: 0, placeId: '', placeFormattedAddress: '',);
      address.placeName = main_text;
      address.placeId = placeId;
      address.latitude =lats ;
      address.longitude =longs ;

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);

      print("This is Drop Off Location :: ");
      print(address.placeName);

      Navigator.pop(context, "obtainDirection");

  }
}