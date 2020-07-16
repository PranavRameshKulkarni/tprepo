import 'dart:convert';
import 'package:flutter_complete/models/LocationModel.dart';
import 'package:http/http.dart' as http;

class Fetch {
  final String url = "http://127.0.0.1:8000/";

  Future<List<LocationModel>> fetchLocation() async {
//    var params = {
//      "doctor_id": "DOC000506",
//      "date_range": "25/03/2019-25/03/2019",
//      "clinic_id": "LAD000404"
//    };

    Uri uri = Uri.parse(url);
//  uri = uri.replace(queryParameters: params);
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
