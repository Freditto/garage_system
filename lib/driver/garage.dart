import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:garage_app/api/api.dart';
import 'package:intl/intl.dart';

class GarageDetailScreen extends StatefulWidget {
  final String? id,
      garage_name,
      description,
      user_id,
      user_latitude,
      user_longitude;

  GarageDetailScreen(
    this.id,
    this.garage_name,
    this.description,
    this.user_id,
    this.user_latitude,
    this.user_longitude,
  );

  @override
  State<GarageDetailScreen> createState() => _GarageDetailScreenState();
}

class _GarageDetailScreenState extends State<GarageDetailScreen> {
  static TextEditingController controllerDate = new TextEditingController();

  request_help() {}

  _requestHelp_API() async {
    print('*********** Request Help function *********');

    var data = {
      'garage_id': widget.id,
      'driver_id': widget.user_id,
      'latitude': widget.user_latitude,
      'longitude': widget.user_longitude,
    };

    print(data);

    var res =
        await CallApi().authenticatedPostRequest(data, 'createFeedRequest');
    if (res == null) {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SearchScreen()));
      } else if (res.statusCode == 400) {
      } else {}
    }
  }

  _appointment_API() async {
    print('*********** Appointment function *********');

    var data = {
      'garage_id': widget.id,
      'driver_id': widget.user_id,
      'date': controllerDate.text,
    };

    print(data);

    var res =
        await CallApi().authenticatedPostRequest(data, 'createFeedAppointment');
    if (res == null) {
      ScaffoldMessenger.of(this.context)
          .showSnackBar(SnackBar(content: Text("Invalid credentials")));
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => SearchScreen()));
      } else if (res.statusCode == 400) {
      } else {}
    }
  }

  appointment() {}

  _appointmentDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Choose Appointment'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      hintText: 'Select Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          controllerDate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    controller: controllerDate),
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            Navigator.of(context).pop();

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => LoginScreen()));
                          },
                          child: Text('Cancel')),

                      SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            _appointment_API();
                            Navigator.of(context).pop();
                          },
                          child: Text('Send')),
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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(widget.garage_name!, style: TextStyle(color: Colors.black)),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.add,
        //       color: Colors.black,
        //     ),
        //     onPressed: () async {

        // do something
        // final PermissionStatus permissionStatus =
        //     await _getPermission();
        // if (permissionStatus ==
        //     PermissionStatus.granted) {
        //   //We can now access our contacts here

        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               SelectContactScreen()));
        // } else {
        //   //If permissions have been denied show standard cupertino alert dialog
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) =>
        //           CupertinoAlertDialog(
        //             title:
        //                 Text('Permissions error'),
        //             content: Text(
        //                 'Please enable contacts access '
        //                 'permission in system settings'),
        //             actions: <Widget>[
        //               CupertinoDialogAction(
        //                 child: Text('OK'),
        //                 onPressed: () =>
        //                     Navigator.of(context)
        //                         .pop(),
        //               )
        //             ],
        //           ));
        // }
        // },
        // )
        // ],
      ),
      bottomNavigationBar: Container(
        height: 130,
        // color: Colors.white,
        padding: EdgeInsets.all(20),
        // margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              spreadRadius: -4,
              blurRadius: 25,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                  // _addStockDialog(context);

                  _appointmentDialog(context);
                },
                height: 40,
                elevation: 0,
                splashColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Appointment",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));

                  _requestHelp_API();
                },
                height: 40,
                elevation: 0,
                splashColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Request Help",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
