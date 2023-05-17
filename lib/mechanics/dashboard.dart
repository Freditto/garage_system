import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/mechanics/mechanics_list.dart';
import 'package:garage_app/mechanics/request_map.dart';
import 'package:garage_app/mechanics/setgarage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var userData, garageData;
  TextEditingController garageNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var status;

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
          MaterialPageRoute(builder: (context) => const GarageLocationScreen()));
    }
  }

  Future<List<RequestList_Items>> fetchRequestListData(context) async {
    print(" Inside List of Request function");

    var res = await CallApi().authenticatedGetRequest(
        'garageFeeds/${userData['garage']['id']}');

    // print(res);
    if (res != null) {
      print(res.body);

      var requestListItensJson = json.decode(res.body)['request'];

      List<RequestList_Items> requestListItems = [];

      for (var f in requestListItensJson) {
        RequestList_Items requestlistItems = RequestList_Items(
          f["feed_id"].toString(),
          f["driver_id"].toString(),
          f["phone"].toString(),
          f["latitude"].toString(),
          f["longitude"].toString(),
          f['is_received'].toString(),
        );
        requestListItems.add(requestlistItems);
      }
      print(requestListItems.length);

      return requestListItems;
    } else {
      return [];
    }
  }

  Future<List<AppointmentList_Items>> fetchAppointmentListData(context) async {
    print(" Inside List of Appointment function");

    var res = await CallApi().authenticatedGetRequest(
        'garageFeeds/${userData['garage']['id']}');

    // print(res);
    if (res != null) {
      print(res.body);

      var appointmentListItensJson = json.decode(res.body)['appointment'];

      List<AppointmentList_Items> appointmentListItems = [];

      for (var f in appointmentListItensJson) {
        AppointmentList_Items appointmentlistItems = AppointmentList_Items(
          f["feed_id"].toString(),
          f["driver_id"].toString(),
          f["phone"].toString(),
          f["appointment_date"].toString(),
          f["created_at"].toString(),
          f["is_received"].toString(),
        );
        appointmentListItems.add(appointmentlistItems);
      }
      print(appointmentListItems.length);

      return appointmentListItems;
    } else {
      return [];
    }
  }

  _logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: const Text(
                    "Are you sure you want to logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
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
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Yes')),

                      const SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No')),
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      // }
                    ])
              ],
            ),
          );
        });
  }

  _StatusDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Accept Request'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: const Text(
                    "Are you sure you want to accept this request",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();

                            var res = await CallApi()
                                .authenticatedGetRequest('toYesRequest/$id');

                            setState(() {});
                          },
                          child: const Text('Yes')),

                      const SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No')),
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      // }
                    ])
              ],
            ),
          );
        });
  }


  _StatusAppointmentDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Accept Request'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: const Text(
                    "Are you sure you want to accept this request",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();

                            var res = await CallApi()
                                .authenticatedGetRequest('toYesAppointment/$id');

                            setState(() {});
                          },
                          child: const Text('Yes')),

                      const SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No')),
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    // color: Colors.blue,
                    ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 40.0,
                      child: CircleAvatar(
                        radius: 40.0,
                        backgroundImage: AssetImage("assets/meclogo.png"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    userData == null
                        ? const Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            userData['username'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                    userData == null
                        ? const Text(
                            '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            userData['phone'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.group_outlined,
                ),
                title: const Text('My Mechanics'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MechanicsListScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.contact_mail_outlined,
                ),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.pop(context);
                  // _changePassword_Dialog(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.feedback_outlined,
                ),
                title: const Text('Feedback'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
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
              child: SizedBox(
                height: 70,
                width: MediaQuery.of(context).size.width - 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                        builder: (context) => // Ensure Scaffold is in context
                            IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () =>
                                    Scaffold.of(context).openDrawer())),
                    const Text(
                      'Online Garage System | Admin',
                      overflow: TextOverflow.ellipsis,
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

        // body: SafeArea(child: _requestListWidget()),

        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 10.0,
              ),
              height: 35.0,
              child: TabBar(
                labelColor: Colors.black,
                // unselectedLabelColor: Colors.black,
                unselectedLabelColor: Theme.of(context).hintColor,
                isScrollable: false,
                // indicator: BoxDecoration(
                //   color: Color(0xFF44B6AF),
                //   borderRadius: BorderRadius.circular(32),
                // ),
                tabs: const [
                  Tab(
                    text: "Requests",
                  ),
                  Tab(
                    text: "Appointments",
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _requestListWidget(),
                  _appointmentListWidget(),
                  // Online_ProductsScreen(),
                  // Center(child: Text("View 4")),
                  // Center(child: Text("View 5")),
                  // Center(child: Text("View 4")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _requestListWidget() {
    return FutureBuilder<List<RequestList_Items>>(
      future: fetchRequestListData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              //itemCount: ProductModel.items.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestMapScreen(
                                  snapshot.data![index].latitude!,
                                  snapshot.data![index].longitude!,
                                )));
                  },
                  onLongPress: () {
                    _StatusDialog(
                      context,
                      snapshot.data![index].feed_id!,
                    );
                  },
                  child: ListTile(
                      title: Text(
                        snapshot.data![index].phone!,
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            height: 30,
                            // width: 30,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                snapshot.data![index].is_received!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text(snapshot.data![index].driver_id!,),
                      leading: const Icon(Icons.person_2_outlined),
                      trailing: const Icon(Icons.more_vert)),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _appointmentListWidget() {
    return FutureBuilder<List<AppointmentList_Items>>(
      future: fetchAppointmentListData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              //itemCount: ProductModel.items.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                     _StatusAppointmentDialog(
                      context,
                      snapshot.data![index].feed_id!,
                    );
                  },

                 
                  child: ListTile(
                      title: Text(
                        snapshot.data![index].phone!,
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            timeago
                              .format(
                                  DateTime.parse(snapshot.data![index].appointment_date!
                                      .toString()),
                                  locale: 'en_short')
                              .toString(),
                          
                          ),

                          const SizedBox(width: 10,),

                          Container(
                            height: 30,
                            // width: 30,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                snapshot.data![index].is_received!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.person_2_outlined),
                      trailing: const Icon(Icons.more_vert)),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class AppointmentList_Items {
  final String? feed_id,
      driver_id,
      phone,
      appointment_date,
      created_at,
      is_received;

  AppointmentList_Items(this.feed_id, this.driver_id, this.phone,
      this.appointment_date, this.created_at, this.is_received);
}

class RequestList_Items {
  final String? feed_id, driver_id, phone, latitude, longitude, is_received;

  RequestList_Items(this.feed_id, this.driver_id, this.phone, this.latitude,
      this.longitude, this.is_received);
}
