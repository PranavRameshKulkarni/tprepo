import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete/models/LocationModel.dart';
import 'package:flutter_complete/screens/Fetch.dart';
import 'package:flutter_complete/screens/signup_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'Constants.dart';
import 'package:location_permissions/location_permissions.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/homescreen';

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
}

class yourApp extends StatefulWidget {
  @override
  _StatefulState createState() => _StatefulState();
}

class _StatefulState extends State<yourApp> {
  List<Marker> markers = [];
  BitmapDescriptor pinLocationIcon;
  Position currentLocation;
  GoogleMapController googleMapController;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<LocationModel> lst;
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
        body: GoogleMap(
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4),
          child: FloatingActionButton(
            elevation: 25.0,
            onPressed: getDataFromUrl,
            child: Icon(
              Icons.gps_fixed,
            ),
          ),
        ));
  }

  getCurrentLocation() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentLocation = position;
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

        addMarker();
//        markers[markerId] = marker;

        _center = LatLng(22.308985, 114.170992);
        googleMapController
            .animateCamera(CameraUpdate.newLatLngZoom(_center, 15));
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
          position: LatLng(22.308985, 114.170992))));
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
    Fetch fetch = new Fetch();
    lst = await fetch.fetchLocation();
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
}
