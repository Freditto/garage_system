import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/mechanics/add_mechanic.dart';
import 'package:garage_app/mechanics/mechanics_list.dart';
import 'package:garage_app/mechanics/setgarage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var userData, garageData;
  TextEditingController garageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _getUserInfo();

    // checkGarageStatus();
    _getGarageInfo();

    
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

    print('_____________________________');

    print(userData['user_id']);
  }

  void _getGarageInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var garageJson = localStorage.getString('garage');
    var garage = json.decode(garageJson!);
    setState(() {
      garageData = garage;
    });
  }

  checkGarageStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("garage") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GarageLocationScreen()));
    }
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
                Icons.group_outlined,
              ),
              title: const Text('My Mechanics'),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MechanicsListScreen()));
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
                    'Garage Service | Admin',
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
    );
  }
}
