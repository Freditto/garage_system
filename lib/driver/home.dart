import 'dart:async';
import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/driver/garage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.8061802, 39.2860074),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  String? _mapStyle;

  var userData;

  LatLng? _currentPosition;

  bool _isLocationFound = true;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
    _getUserInfo();

    // fetchGarageListData(context);

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<CameraPosition> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLocationFound = false;
    });

    print('%%%%%%%%%%%%%%%%%%%%%');
    print(_currentPosition!.latitude.toString());
    print(_currentPosition!.longitude.toString());

    return CameraPosition(
        bearing: 192.8334901395799,
        target: location,
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  _logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    "Are you sure you want to logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            // _deleteSingleProductTocart(index);
                            // logOUT_User();
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.of(context).pop();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text('Yes')),

                      SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No')),
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      // }
                    ])
              ],
            ),
          );
        });
  }

// Set<LatLng> _latLngList = {
//   LatLng(37.4219999,-122.0840575),
//   LatLng(37.42796133580664,-122.085749655962),
//   LatLng(37.428065,-122.084637)
// };

// GoogleMap(
//   initialCameraPosition: CameraPosition(
//     target: LatLng(37.4219999,-122.0840575),
//     zoom: 12,
//   ),
//   markers: _createMarkers(),
// )

// Set<Marker> _createMarkers() {
//   return _latLngList.map((LatLng latLng) {
//     return Marker(
//       markerId: MarkerId(latLng.toString()),
//       position: latLng,
//       icon: BitmapDescriptor.defaultMarker,
//     );
//   }).toSet();
// }

  fetchGarageListData(context) async {
    print(" Inside List of Garages function");

    LocationPermission permission;
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLocationFound = false;
    });

    print(_currentPosition!.latitude.toString());

    var res = await CallApi().authenticatedGetRequest('nearBy?long=' +
        _currentPosition!.longitude.toString() +
        '&lat=' +
        _currentPosition!.latitude.toString());

    print(res);
    if (res != null) {
      print(res.body);
      var body = json.decode(res.body);

      var garageListItensJson = json.decode(res.body);

      // List<GarageList_Items> _garageListItems = [];
      Set<Marker> _markerListItems = {};

      for (var f in garageListItensJson) {
        // GarageList_Items garageList_items = GarageList_Items(
        //   f["id"].toString(),
        //   f["name"].toString(),
        //   f["distance"].toString(),
        //   f["description"].toString(),
        //   f["latitude"].toString(),
        //   f["longitude"].toString(),
        // );
        print("chochote unachotaka_________");

        Marker my_mark = Marker(
          markerId: MarkerId(f['id'].toString()),
          position: LatLng(double.parse(f['latitude'].toString()),
              double.parse(f['longitude'].toString())),
          icon: markerIcon,
          onTap: () {
            print('pin tapped ');
             
            // InfoWindow(
            //   title: 'Marker Title Second ',
            //   snippet: 'My Custom Subtitle',
            // );
          },
          infoWindow: InfoWindow(
            title: f['name'],
            snippet: f['description'],
            onTap: () {
            // InfoWindow clicked
            Navigator.push(
              context, MaterialPageRoute(builder: (context) => GarageDetailScreen(
                f["id"].toString(),
                f["name"].toString(),
                f["description"].toString(),

                userData['user_id'].toString(),
                 _currentPosition!.latitude.toString(),
                  _currentPosition!.longitude.toString(),
              )));
            }
          ),
        );
        _markerListItems.add(my_mark);
      }

      print('Marj=sdsd');
      print(_markerListItems);

      setState(() {
        allMarkers = _markerListItems;
      });

      return _markerListItems;
    } else {
      return {};
    }
  }

  var allMarkers = <Marker>{};

  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    minRadius: 40.0,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage("assets/user1.jpg"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Leonardo Palmeiro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Flutter Developer',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.notifications_outlined,
              ),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.contact_mail_outlined,
              ),
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.pop(context);
                // _changePassword_Dialog(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.feedback_outlined,
              ),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);

                _logoutDialog(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.0,
        // leading: Builder(builder: (context) => // Ensure Scaffold is in context
        //       IconButton(
        //          icon: Icon(Icons.menu),
        //          onPressed: () => Scaffold.of(context).openDrawer()
        //    )),

        // title: Text('Recruitment Portal',
        //     style: TextStyle(fontSize: 16, color: Colors.black) ,
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width - 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                      builder: (context) => // Ensure Scaffold is in context
                          IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer())),
                  Text(
                    'Online Garage System',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8.0),
                        child: Stack(
                          children: [
                            IconButton(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => NotificationScreen()));
                                },
                                icon: const Icon(Icons.more_vert)),
                            // Positioned(
                            //   right: 0,
                            //   child: Badge(
                            //     badgeContent: Text(
                            //       '0',
                            //       style: const TextStyle(color: Colors.white),
                            //     ),
                            //     badgeColor: Colors.red,
                            //     borderRadius: BorderRadius.circular(4),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 4, right: 8.0),
                      //   child: IconButton(
                      //     onPressed: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => ProfileScreen()));
                      //     },
                      //     icon: const Image(
                      //       height: 24,
                      //       image: AssetImage("assets/user.png"),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),

     

      body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            // mapController.setMapStyle(_mapStyle);
          },
          markers: allMarkers
          // markers:{
          //   Marker(
          //     markerId: const MarkerId("marker1"),
          //     position: const LatLng(-6.8061802, 39.2860074),
          //     onTap: () {},
          //     draggable: true,
          //     onDragEnd: (value) {
          //       // value is the new position
          //     },
          //     icon: markerIcon,
          //     infoWindow: InfoWindow(
          //   title: 'Marker Title Second ',
          //   snippet: 'My Custom Subtitle',
          // ),
          //   ),
          //   Marker(
          //     markerId: const MarkerId("marker2"),
          //     position: const LatLng(-6.8061802, 38.2860074),
          //     onTap: () {},
          //     draggable: true,
          //     onDragEnd: (value) {
          //       // value is the new position
          //     },
          //     icon: markerIcon,
          //   ),
          // },
          ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(userData);
          _goToTheLocation();
         
        },
        label: const Text('Locate me'),
        icon: const Icon(Icons.gps_fixed_outlined),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _goToTheLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(await getLocation()));

    fetchGarageListData(context);
  }

  
}

class GarageList_Items {
  final String? id, name, distance, description, latitude, longitude;

  GarageList_Items(this.id, this.name, this.distance, this.description,
      this.latitude, this.longitude);
}
