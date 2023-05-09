import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestMapScreen extends StatefulWidget {
  String? latitude, longitude;

  RequestMapScreen(this.latitude, this.longitude);

  @override
  State<RequestMapScreen> createState() => _RequestMapScreenState();
}

class _RequestMapScreenState extends State<RequestMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition? _kGooglePlex;

  // final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(double.parse(widget.latitude!), double.parse(widget.longitude!)),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    print("_______________REache Request Map______");
    setState(() {
      _kGooglePlex =  CameraPosition(
        target: LatLng(double.parse(widget.latitude!), double.parse(widget.longitude!)),
        zoom: 14.4746,
      );
      
    });

  

    print(widget.latitude);
    print(widget.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex!,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // mapController.setMapStyle(_mapStyle);
        },
        // markers: allMarkers
        markers: {
          Marker(
            markerId: const MarkerId("marker1"),
            position: LatLng(double.parse(widget.latitude!),
                double.parse(widget.longitude!)),
            onTap: () {},
            draggable: true,
            onDragEnd: (value) {
              // value is the new position
            },
            icon: markerIcon,
            infoWindow: InfoWindow(
              title: 'Marker Title Second ',
              snippet: 'My Custom Subtitle',
            ),
          ),
        },
      ),
    );
  }
}
