class PlacePredictions
{
  String secondary_text="";
  String main_text="";
  String place_id="";
  double lats=0;
  double longs=0;
  PlacePredictions({required this.secondary_text, required this.main_text, required this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json)
  {
    place_id = json["place_id"];
    main_text = json["display_name"];
    secondary_text = json["display_place"];
    lats=double.parse(json["lat"]);
    longs=double.parse(json["lon"]);
  }
}