import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/mechanics/setgarage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

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
        'driverFeeds/${userData['user_id']}');

    print(res);
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
        'driverFeeds/${userData['user_id']}');

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

  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 70.0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.0,
          // leading: Builder(builder: (context) => // Ensure Scaffold is in context
          //       IconButton(
          //          icon: Icon(Icons.menu),
          //          onPressed: () => Scaffold.of(context).openDrawer()
          //    )),

          title: Text('Notifications',
              style: TextStyle(fontSize: 16, color: Colors.black) ,
          ),
         
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => RequestMapScreen(
                    //               snapshot.data![index].latitude!,
                    //               snapshot.data![index].longitude!,
                    //             )));
                  },
                  onLongPress: () {
                    // _StatusDialog(
                    //   context,
                    //   snapshot.data![index].feed_id!,
                    // );
                  },
                  child: ListTile(
                      title: snapshot.data![index].is_received! == 'yes' 
                      ? Text(
                        'Your Request has been approved',
                        )
                      : Text(
                        'Your Request has not been approved yet',
                        ),
                      subtitle: snapshot.data![index].is_received! == 'yes' 
                      ?
                       Row(
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
                                'Help is on the way',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                      :
                      
                      Row(
                        children: [
                          Container(
                            height: 30,
                            // width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Waiting garage approval',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],),
                      // Text(snapshot.data![index].driver_id!,),
                      // leading: const Icon(Icons.person_2_outlined),
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
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => RequestMapScreen(
                    //               snapshot.data![index].latitude!,
                    //               snapshot.data![index].longitude!,
                    //             )));
                  },
                  onLongPress: () {
                    // _StatusDialog(
                    //   context,
                    //   snapshot.data![index].feed_id!,
                    // );
                  },
                  child: ListTile(
                      title: snapshot.data![index].is_received! == 'yes' 
                      ? Text(
                        'Your Appointment has been approved',
                        )
                      : Text(
                        'Your Appointment has not been approved yet',
                        ),
                      subtitle: snapshot.data![index].is_received! == 'yes' 
                      ?
                       Row(
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
                                'Schedule created',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                      :
                      
                      Row(
                        children: [
                          Container(
                            height: 30,
                            // width: 30,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Waiting garage approval',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],),
                      // Text(snapshot.data![index].driver_id!,),
                      // leading: const Icon(Icons.person_2_outlined),
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
