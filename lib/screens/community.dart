// ignore_for_file: avoid_print

import 'package:btechshayak/screens/menu.dart';
import 'package:btechshayak/screens/group_tile.dart';
import 'package:btechshayak/screens/widgets.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:btechshayak/service/database_service.dart';
import 'package:btechshayak/service/titleCase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Community extends ConsumerStatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  ConsumerState<Community> createState() => _CommunityState();
}

class _CommunityState extends ConsumerState<Community> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    //  getting the list of snapshot in our stream
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                // nextScreen(context, const SearchPage());
              },
              icon: const Icon(
                Icons.search,
              ))
        ],
        centerTitle: true,
        title: const Text(
          "Groups",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const Menu(),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: const EdgeInsets.symmetric(vertical: 50),
      //     children: <Widget>[
      //       Icon(
      //         Icons.account_circle,
      //         size: 150,
      //         color: Colors.grey[700],
      //       ),
      //       const SizedBox(
      //         height: 15,
      //       ),
      //       Text(
      //         userName,
      //         textAlign: TextAlign.center,
      //         style: const TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(
      //         height: 30,
      //       ),
      //       const Divider(
      //         height: 2,
      //       ),
      //       ListTile(
      //         onTap: () {},
      //         selectedColor: Theme.of(context).primaryColor,
      //         selected: true,
      //         contentPadding:
      //             const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      //         leading: const Icon(Icons.group),
      //         title: const Text(
      //           "Groups",
      //           style: TextStyle(color: Colors.black),
      //         ),
      //       ),
      //       ListTile(
      //         onTap: () {
      //           // nextScreenReplace(
      //           //     context,
      //           //     ProfilePage(
      //           //       userName: userName,
      //           //       email: email,
      //           //     ));
      //         },
      //         contentPadding:
      //             const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      //         leading: const Icon(Icons.person_pin),
      //         title: const Text(
      //           "Profile",
      //           style: TextStyle(color: Colors.black),
      //         ),
      //       ),
      //       // ListTile(
      //       //   onTap: () async {
      //       //     showDialog(
      //       //         barrierDismissible: false,
      //       //         context: context,
      //       //         builder: (context) {
      //       //           return AlertDialog(
      //       //             title: const Text("Logout"),
      //       //             content: const Text("Are you sure you wanna logout☹️"),
      //       //             actions: [
      //       //               IconButton(
      //       //                 onPressed: () {
      //       //                   Navigator.pop(context);
      //       //                 },
      //       //                 icon: const Icon(
      //       //                   Icons.cancel,
      //       //                   color: Colors.red,
      //       //                 ),
      //       //               ),
      //       //               IconButton(
      //       //                 onPressed: () async {
      //       //                   await authService.signOut();
      //       //                   Navigator.of(context).pushAndRemoveUntil(
      //       //                       MaterialPageRoute(
      //       //                           builder: (context) => const LoginPage()),
      //       //                       (route) => false);
      //       //                 },
      //       //                 icon: const Icon(
      //       //                   Icons.exit_to_app,
      //       //                   color: Colors.green,
      //       //                 ),
      //       //               ),
      //       //             ],
      //       //           );
      //       //         });
      //       //   },
      //       //   contentPadding:
      //       //       const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      //       //   leading: const Icon(Icons.exit_to_app),
      //       //   title: const Text(
      //       //     "Logout",
      //       //     style: TextStyle(color: Colors.black),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(15),
                              )),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  // style: ElevatedButton.styleFrom(
                  //   Color: Theme.of(context).primaryColor,
                  // ),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DataBaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnakbar(context, Colors.green,
                            "Group created successfully.😍");
                      });
                    }
                  },
                  // style: ElevatedButton.styleFrom(
                  //   primary: Theme.of(context).primaryColor,
                  // ),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: ref.read(firestoreProvider).getGroup(),
      builder: (context, AsyncSnapshot snapshot) {
        // make some check
        if (snapshot.hasData) {
          final document = snapshot.requireData;
          print('data ${document.docs.length}');
          if (document.docs.length != 0) {
            return ListView.builder(
              itemCount: document.docs.length,
              itemBuilder: (context, index) {
                final data = document.docs[index].data();
                return GroupTile(
                  groupName: titleCase(data['groupName']),
                  groupId: data['groupId'],
                );
              },
            );
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              )),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group otherwise search from top search button",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
