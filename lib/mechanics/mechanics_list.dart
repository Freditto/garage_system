import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/mechanics/add_mechanic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicsListScreen extends StatefulWidget {
  @override
  State<MechanicsListScreen> createState() => _MechanicsListScreenState();
}

class _MechanicsListScreenState extends State<MechanicsListScreen> {
  var userData;

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

  Future<List<EngineerList_Items>> fetchEngineerListData(context) async {
    print(" Inside List of Engineers function");

    var res = await CallApi().authenticatedGetRequest('viewEngineers/' + userData['garage']['id'].toString());

    // print(res);
    if (res != null) {
      print(res.body);
      var body = json.decode(res.body);

      var engineerListItensJson = json.decode(res.body);

      List<EngineerList_Items> _engineerListItems = [];

      for (var f in engineerListItensJson) {
        EngineerList_Items engineerList_items = EngineerList_Items(
          f["id"].toString(),
          f["username"].toString(),
          f["phone"].toString(),
          f["description"].toString(),
        );
        _engineerListItems.add(engineerList_items);
      }
      print(_engineerListItems.length);

      return _engineerListItems;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text('All Mechanics', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onPressed: () async {},
          )
        ],
      ),


      body: SafeArea(
        child: _engineerListWidget()
        
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddMechanicScreen()));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _engineerListWidget() {
    return FutureBuilder<List<EngineerList_Items>>(
      future: fetchEngineerListData(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
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
                    //         builder: (context) => DetailStationsry(
                    //               snapshot.data![index].id!,
                    //               snapshot.data![index].username!,
                    //               snapshot.data![index].phone!,
                    //               snapshot.data![index].description!,
                                  
                    //             )));
                  },
                  child: ListTile(
                    title: Text(snapshot.data![index].username!,),
                    subtitle: Text(snapshot.data![index].description!,),
                    leading: Icon(Icons.person_2_outlined),
                    trailing: Icon(Icons.more_vert)),
                      );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class EngineerList_Items {
  final String? id, username, phone, description;

  EngineerList_Items(this.id, this.username, this.phone, this.description);
}
