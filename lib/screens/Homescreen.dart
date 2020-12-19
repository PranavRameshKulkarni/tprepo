import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete/models/LocationModel.dart';
import 'package:flutter_complete/screens/Fetch.dart';
import 'package:flutter_complete/screens/signup_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'Constants.dart';
import 'package:http/http.dart' as http;
import 'package:location_permissions/location_permissions.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:material_search/material_search.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/homescreen';
  static Position currentPosition;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoogleMaps',
      home: Scaffold(
        body: yourApp(),
      ),
    );
  }

  setPostition(pos) {
    currentPosition = pos;
  }

  getPosition() {
    return currentPosition;
  }
}

class yourApp extends StatefulWidget {
  @override
  _StatefulState createState() => _StatefulState();
}

class _StatefulState extends State<yourApp> {
  List<Marker> markers = [];
  BitmapDescriptor pinLocationIcon;
  Position currentLocation;
  Position loc;
  GoogleMapController googleMapController;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<LocationModel> lst;
  HomeScreen hm = new HomeScreen();

  @override
  void initState() {
    super.initState();
//    addMarker();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/1_qvmBfugDqSF1lmv5fD62aQ.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });

    getPermission();
    getCurrentLocation();
  }

  static LatLng _center = LatLng(28.7041, 77.1025);

  @override
  Widget build(BuildContext context) {
    print('centre $markers');

    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.home,
              ),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map(
                  (String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  },
                ).toList();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: handlesearch,
            ),
          ],
          title: Text('HOme screen'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text('pranav.kulkarni54@gmail.com'),
                accountName: Text('private'),
                currentAccountPicture: Icon(
                  Icons.person,
                ),
              ),
              ListTile(
                title: Text('Profile'),
                trailing: Icon(
                  Icons.person,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SignupScreen()));
                },
              ),
              ListTile(
                title: Text('Settings'),
                trailing: Icon(
                  Icons.settings,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController mapController) {
                googleMapController = mapController;
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers: !(markers.isEmpty) ? markers.toSet() : null,
            ),
//            FloatingSearchBar(),
//            FloatingSearchBar.builder(
//              pinned: true,
//              body: ,
////              itemCount: 100,
//              padding: EdgeInsets.only(top: 10.0),
//              itemBuilder: (BuildContext context, int index) {
//                return null;
//              },
//              leading: Icon(
//                Icons.search,
//              ),
//              onChanged: (String value) {},
//              onTap: () {},
//              decoration: InputDecoration.collapsed(
//                hintText: "Search...",
//              ),
//            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
          child: FloatingActionButton(
            elevation: 25.0,
            onPressed: fetchData,
            child: Icon(
              Icons.gps_fixed,
            ),
          ),
        ));
  }

  void onError(PlacesAutocompleteResponse response) {
    print(response);
  }

//  materialSearch() {
//    return MaterialSearch(
//      placeholder: 'Search',
//      getResults: null,
//    );
//  }

  handlesearch() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyDlaKY3Bx8D2rDkC1A0lSuq1cj2Habu4pw",
      onError: onError,
      types: ["(cities)"],
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "in")],
    );
    displayResult(p);
  }

  displayResult(Prediction p) async {
    GoogleMapsPlaces _places =
        GoogleMapsPlaces(apiKey: 'AIzaSyDlaKY3Bx8D2rDkC1A0lSuq1cj2Habu4pw');
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      Position p1 = new Position(latitude: lat, longitude: lng);
      setlocation(p1);
      addMarker();
    }
  }

  getCurrentLocation() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentLocation = position;
        setlocation(position);
//        final MarkerId markerId = MarkerId('2');
//        final Marker marker = Marker(
//          position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        );
//        markers[markerId] = marker;

        markers.add(
          Marker(
            icon: pinLocationIcon,
            markerId: MarkerId('current_position'),
            infoWindow: InfoWindow(
              title: 'This is current location',
            ),
            position:
                LatLng(currentLocation.latitude, currentLocation.longitude),
          ),
        );
        _center = LatLng(currentLocation.latitude, currentLocation.longitude);
        googleMapController
            .animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
      });
    }).catchError((e) {
      print(e);
    });

    print('centre $_center');
  }

  void getPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    print('permission $permission');
    if (permission != null) {
      print('hello');
    }
  }

  void getCity(String city) async {
    currentLocation = await Geolocator()
        .placemarkFromAddress('$city')
        .then((List<Placemark> myList) {
      setState(() {
        Placemark newPlace = myList.first;
        currentLocation = newPlace.position;
        setlocation(currentLocation);
        addMarker();
//        markers[markerId] = marker;

        _center = LatLng(loc.latitude, loc.longitude);
        googleMapController
            .animateCamera(CameraUpdate.newLatLngZoom(_center, 10));
      });
    }).catchError((e) {
      print(e);
    });
  }

  void addMarker() {
    print("Inside add marker method");
    setState(() {
      markers.add((Marker(
          markerId: MarkerId('City'),
          position: LatLng(loc.latitude, loc.longitude))));
    });
    print('markers $markers');
  }

  void choiceAction(String value) {
    switch (value) {
      case Constants.pune:
        getCity('Pune');
        break;
      case Constants.mumbai:
        getCity('Mumbai');
        break;
      case Constants.nashik:
        getCity('Nashik');
        break;
      case Constants.banglore:
        getCity('Banglore');
        break;
      case Constants.satara:
        getCity('Satara');
        break;
    }
  }

  void getDataFromUrl() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentLocation = position;
        print(currentLocation);
//        fetchData(currentLocation);
//        lst = await fetch.fetchLocation(
//            currentLocation.latitude, currentLocation.longitude, 'wifi');
//        print(lst[0].address);
//        for (int i = 0; i < lst.length; i++) {
//          markers.add(
//            Marker(
//              markerId: MarkerId('pos$i'),
//              position: LatLng(lst[i].lat, lst[i].long),
//              infoWindow: InfoWindow(title: 'location $i'),
//            ),
//          );
//        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  fetchData() async {
    print(loc);
    Fetch fetch = new Fetch();
    lst = await fetch.fetchLocation(loc.latitude, loc.longitude, 'wifi');
    print(lst[0].address);
    setState(() {
      for (int i = 0; i < lst.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId('pos$i'),
            position: LatLng(lst[i].lat, lst[i].long),
            infoWindow: InfoWindow(title: 'location $i'),
          ),
        );
      }
    });
  }

  setlocation(location) {
    loc = location;
    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(loc.latitude, loc.longitude), 10));
  }
}

class search extends SearchDelegate<String> {
  List list = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //todo: Implement what the function should do after selecting an item
    HomeScreen.currentPosition = null;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.local_airport),
        title: Text(list[index]),
      ),
      itemCount: list.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var hello;
    var response = http
        .get(
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(cities)&key=AIzaSyDlaKY3Bx8D2rDkC1A0lSuq1cj2Habu4pw')
        .then((value) {
      list.clear();
      hello = json.decode(value.body);
      var bye = hello['predictions'];
      for (int i = 0; i < bye.length; i++) {
        String name = bye[i]['description'];
        List l1 = name.split(', ');

        var string = '';
        for (var j in l1) {
          string += ' $j';
        }
        list.add(string);
      }
      print(list);
    });
    final suggestions = query.isEmpty ? [] : list;
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          close(context, null);
        },
        leading: Icon(Icons.local_airport),
        title: Text(suggestions[index]),
      ),
      itemCount: suggestions.length,
    );
  }

//  getDetails(query) async {
//    var hello;
//    var response = http
//        .get(
//            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(cities)&key=AIzaSyDlaKY3Bx8D2rDkC1A0lSuq1cj2Habu4pw')
//        .then((value) {
//      list.clear();
//      hello = json.decode(value.body);
//      var bye = hello['predictions'];
//      for (int i = 0; i < bye.length; i++) {
//        String name = bye[i]['description'];
//        List l1 = name.split(', ');
//
//        var string = '';
//        for (var j in l1) {
//          string += ' $j';
//        }
//        list.add(string);
//      }
//      print(list);
//    });
//  }
}
