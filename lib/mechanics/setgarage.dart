import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/constant.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GarageLocationScreen extends StatefulWidget {
  const GarageLocationScreen({super.key});

  @override
  State<GarageLocationScreen> createState() => _GarageLocationScreenState();
}

class _GarageLocationScreenState extends State<GarageLocationScreen> {

  final _formKey = GlobalKey<FormState>();

  var userData;
  TextEditingController garageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _getUserInfo();

   
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.8061802, 39.2860074),
    zoom: 14.4746,
  );


  LatLng? _currentPosition;

  bool _isLocationFound = true;

  Future<CameraPosition> getLocation() async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
      _isLocationFound = false;
    });
    return CameraPosition(
        bearing: 192.8334901395799,
        target: location,
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }


  _additonal_Info_Dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Additional Information')),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    TextFormField(
                    controller: garageNameController,
                    // validator: validateEmail,
                    // keyboardType: TextInputType.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.kPlaceholder3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Garage Name',
                      hintStyle: const TextStyle(
                        color: AppColor.kTextColor1,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  TextFormField(
                    controller: descriptionController,
                    // validator: validateEmail,
                    // keyboardType: TextInputType.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColor.kPlaceholder3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Description',
                      hintStyle: const TextStyle(
                        color: AppColor.kTextColor1,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),
                    MaterialButton(
                      onPressed: () {
                       _registerGarage_API();
                       Navigator.pop(this.context);
                      },
                      // onPressed: () {
                      //   // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                      //   // print('something should print');

                      // },
                      height: 40,
                      elevation: 0,
                      splashColor: const Color.fromRGBO(104, 57, 183, 100),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: const Color.fromRGBO(104, 57, 183, 100),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _registerGarage_API() async {
    print('*********** Register Garage function *********');
    print(userData.toString());

    var data = {
      // 'consumer': userData['id'].toString(),
      'name': garageNameController.text,
      'description': descriptionController.text,
      'longitude': _currentPosition!.longitude,
      'latitude': _currentPosition!.latitude,
      'user_id': userData['user_id'],
      // 'wholesale_price': wholesale_priceController.text
    };

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'registerGarage');
    if (res == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Data Not saved!")));
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        // localStorage.setString("token", body['token']);
        localStorage.setString("garage", json.encode(body));
        // localStorage.setString("token", json.encode(body['token']));

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Data saved Successfuly!")));
      } else if (res.statusCode == 400) {
      } else {}
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // mapController.setMapStyle(_mapStyle);
        },
      ),
      floatingActionButton: _isLocationFound
          ? FloatingActionButton.extended(
              onPressed: _goToTheLocation,
              label: const Text('Locate Me'),
              backgroundColor: Colors.green,
              icon: const Icon(Icons.gps_fixed),
            )
          : FloatingActionButton.extended(
              onPressed: (() {
                _additonal_Info_Dialog(context);
              }),
              label: const Text('Continue'),
              backgroundColor: const Color.fromRGBO(104, 57, 183, 100),
              icon: const Icon(Icons.gps_fixed),
            ),
    );
  }

  Future<void> _goToTheLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(await getLocation()));
  }
}