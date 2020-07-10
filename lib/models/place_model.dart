class PlaceModel {
  String icon;
  String id;
  String name;
  String rating;
  String vicinity;

  String formatted_address;
  // ignore: non_constant_identifier_names
  String international_phone_number;
  List<String> weekday_text;
  String url;

  PlaceModel(this.id, this.name, this.icon, this.rating, this.vicinity,
      [this.formatted_address,
      this.international_phone_number,
      this.weekday_text]);
}
