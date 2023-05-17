import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/mechanics/add_mechanic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicsListScreen extends StatefulWidget {
  const MechanicsListScreen({super.key});

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

  Future<List<EngineerList_Items>> fetchEngineerListData(context) async {
    print(" Inside List of Engineers function");

    var res = await CallApi().authenticatedGetRequest('viewEngineers/${userData['garage']['id']}');

    // print(res);
    if (res != null) {
      print(res.body);

      var engineerListItensJson = json.decode(res.body);

      List<EngineerList_Items> engineerListItems = [];

      for (var f in engineerListItensJson) {
        EngineerList_Items engineerlistItems = EngineerList_Items(
          f["id"].toString(),
          f["username"].toString(),
          f["phone"].toString(),
          f["description"].toString(),
        );
        engineerListItems.add(engineerlistItems);
      }
      print(engineerListItems.length);

      return engineerListItems;
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
        title: const Text('All Mechanics', style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
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
              MaterialPageRoute(builder: (context) => const AddMechanicScreen()));
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

class EngineerList_Items {
  final String? id, username, phone, description;

  EngineerList_Items(this.id, this.username, this.phone, this.description);
}
