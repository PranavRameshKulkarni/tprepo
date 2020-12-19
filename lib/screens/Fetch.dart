import 'dart:convert';
import 'package:flutter_complete/models/LocationModel.dart';
import 'package:http/http.dart' as http;

class Fetch {
  final String url = "https://hackelite.herokuapp.com/places/";

  Future<List<LocationModel>> fetchLocation(lat, lng, query) async {
    var params = {
      "lat": lat.toString(),
      "lng": lng.toString(),
      "query": query,
    };

    Uri uri = Uri.parse(url);
    uri = uri.replace(queryParameters: params);
    final response = await http.get(uri, headers: {
      'Token': 'new token',
    });

    if (response.statusCode == 200) {
      var array;
      array = json.decode(response.body);
      var len = array.length;
      var locationList = new List<LocationModel>();
      for (var i = 0; i < len; i++) {
        locationList.add(
          LocationModel(
            lat: array[i]['lat'],
            long: array[i]['lng'],
            address: array[i]['address'],
            name: array[i]['name'],
          ),
        );
      }
      print(locationList[0].lat);
      return locationList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load location');
    }
  }
}
