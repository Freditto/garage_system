import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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


                Text('Garage Service | Admin', 
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


    floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          //  Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => Personal_CV_Screen()));
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
