import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

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

                // _logoutDialog(context);
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
                

                Builder(builder: (context) => // Ensure Scaffold is in context
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer()
                )),


                Text('Garage Service', 
                  style: TextStyle(fontSize: 16, color: Colors.black) ,
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
                            icon: const Icon(
                              Icons.more_vert
                            )
                          ),
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
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Personal_CV_Screen()));
        },
        label: const Text('Locate me'),
        icon: const Icon(Icons.gps_fixed_outlined),
        backgroundColor: Colors.green,
      ),
    );
  }
}
