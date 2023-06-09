import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garage_app/api/api.dart';
import 'package:garage_app/constant.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMechanicScreen extends StatefulWidget {
  const AddMechanicScreen({super.key});

  @override
  State<AddMechanicScreen> createState() => _AddMechanicScreenState();
}

class _AddMechanicScreenState extends State<AddMechanicScreen> {
  final _formKey = GlobalKey<FormState>();

  var userData;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _getUserInfo();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  _addMechanic_API() async {
    print('*********** Add Mechanic function *********');
    print(userData.toString());

    var data = {
      'garage_id': userData['garage']['id'],
      'username': nameController.text,
      'description': descriptionController.text,
      'phone': phoneController.text,
    };

    print(data);

    var res =
        await CallApi().authenticatedPostRequest(data, 'registerEngineer');
    if (res == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid credentials")));
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

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA

      _addMechanic_API();
      Navigator.pop(context);
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
        title:
            const Text('Add Mechanics', style: TextStyle(color: Colors.black)),
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                children: [
                  buildImage(),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 4,
                  //   child: buildEditIcon(Colors.blue),
                  // ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: validateMechanicname,
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
                      hintText: 'Mechanic Name',
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
                    validator: validateArea,
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
                      hintText: 'Area Of Speciality',
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
                    controller: phoneController,
                    validator: validatePhone,
                    keyboardType: TextInputType.phone,
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
                      hintText: 'Phone Number',
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

                  // TextFormField(
                  //   // controller: userPasswordController,
                  //   // obscureText: true,
                  //   // validator: validatePassword,
                  //   // keyboardType: TextInputType.phone,
                  //   style: Theme.of(context).textTheme.bodyMedium,
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: AppColor.kPlaceholder3,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(
                  //         8,
                  //       ),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //     hintText: 'Password',
                  //     hintStyle: const TextStyle(
                  //       color: AppColor.kTextColor1,
                  //       fontSize: 14,
                  //     ),
                  //     contentPadding: const EdgeInsets.symmetric(
                  //       horizontal: 12,
                  //       vertical: 8,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              elevation: 0,
              color: Colors.green,
              height: 50,
              minWidth: 500,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                _submit();
                
                // _login();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => OTP_Screen(),
                //   ),
                // );
              },
              child: const Text(
                'Save Mechanic',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    const image = AssetImage("assets/user1.jpg");

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () {}),
        ),
      ),
    );
  }

  String? validateMechanicname(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Mechanic name Field must not be empty';
    } else {
      return null;
    }
  }

  String? validateArea(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Area of speciality Field must not be empty';
    } else {
      return null;
    }
  }

  String? validatePhone(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Phone Number Field must not be empty';
    } else {
      return null;
    }
  }
}
