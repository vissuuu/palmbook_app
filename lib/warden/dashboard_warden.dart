// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:palmbook_ios/main.dart';
import 'package:palmbook_ios/warden/gatepass_requests.dart';
import 'package:image_picker/image_picker.dart';
import '../common/discussion.dart';
import '../common/mess_menu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io' if (dart.library.win32) 'package:win32/win32.dart';
import 'package:intl/intl.dart';

class dashboard_warden extends StatefulWidget {
  const dashboard_warden({Key? key}) : super(key: key);

  @override
  State<dashboard_warden> createState() => _dashboard_wardenState();
}

class _dashboard_wardenState extends State<dashboard_warden> {
  var dt = DateTime.now();
  File? _selectedImage;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7785FC),
        elevation: 0,
        title: const Text("PalmBook"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF7785FC),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .where('uid', isEqualTo: user?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.docs.isNotEmpty) {
                          final DocumentSnapshot doc = snapshot.data!.docs[0];
                          final profileImage = doc['profile_image'] as String?;

                          return Column(
                            children: [
                              if (profileImage == null || profileImage.isEmpty)
                                Column(
                                  children: [
                                    Icon(
                                      Icons.supervised_user_circle,
                                      size: width * .1,
                                      color: Colors.white,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _selectImage();
                                      },
                                      child: Container(
                                        height: width * .07,
                                        width: width * .3,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border:
                                              Border.all(color: Colors.black38),
                                        ),
                                        child: const Center(
                                            child: Text("Upload Image")),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                InkWell(
                                  onTap: () {
                                    _selectImage();
                                  },
                                  child: Container(
                                    width: width * .15,
                                    height: width * .15,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(profileImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                doc['Name'] != null
                                    ? doc['Name'] as String
                                    : 'No Name',
                                style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          );
                        } else {
                          // No documents found in the query results
                          return const Center(
                            child: Text('Error'),
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // InkWell(
                        //   onTap: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context) => test3(),));
                        //   },
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Image.asset("assets/icons/dashboard_black_24dp (1) 1.png"),
                        //       const SizedBox(
                        //         width: 20,
                        //       ),
                        //       const Text("Community",
                        //         style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 16
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const menu(),
                                ));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.restaurant,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                "Mess Menu",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () => signOut(context),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text(
                                "Log Out",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              "assets/images/DRIP_17.png",
              height: width * .65,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * .05),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: width * .05),
                child: Container(
                  width: width * .9,
                  height: 200,
                  decoration: BoxDecoration(
                      color: const Color(0xFF7785FC),
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Check",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Gatepass",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Requests",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const gatepass_requests(),
                                  ));
                            },
                            child: Container(
                              height: 25,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.5)),
                              child: const Center(
                                child: Text(
                                  "Review Requests",
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xFF7785FC)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Image.asset("assets/images/DRIP_18.png")
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: width * .07, left: width * 0.03, right: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Mess Menu",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const menu(),
                            ));
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: const Color(0xFF7785FC),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Center(
                          child: Text(
                            "View all",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: width * .07),
                child: DefaultTabController(
                  length: 4,
                  initialIndex: (dt.hour >= 0 && dt.hour < 10)
                      ? 0
                      : (dt.hour >= 10 && dt.hour < 15)
                          ? 1
                          : (dt.hour >= 15 && dt.hour < 18)
                              ? 2
                              : 3,
                  child: Container(
                    width: width * .9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF979797)
                                .withOpacity(0.1), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 1, // Blur radius
                            offset: const Offset(2, 4),
                          )
                        ]),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                          child: TabBar(
                            splashFactory: NoSplash.splashFactory,
                            labelPadding:
                                EdgeInsets.symmetric(horizontal: 12.0),
                            tabs: [
                              Tab(
                                text: "Breakfast",
                              ),
                              Tab(
                                text: "Lunch",
                              ),
                              Tab(
                                text: "Snacks",
                              ),
                              Tab(
                                text: "Dinner",
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('mess')
                              .doc(formattedDate) // Fetch today's document
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasData && snapshot.data!.exists) {
                              final DocumentSnapshot menu = snapshot.data!;

                              return SizedBox(
                                height: 150,
                                child: TabBarView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        menu["breakfast"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        menu["lunch"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        menu["snacks"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        menu["dinner"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // No documents found in the query results

                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text('Menu not updated'),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    if (await _selectedImage!.length() < 2 * 1024 * 1024) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("profile_pictures/$firebaseUser.uid");
        UploadTask uploadTask = storageReference.putFile(_selectedImage!);

        TaskSnapshot snapshot = await uploadTask;

        // Get the download URL of the uploaded image.
        String _imageURL = await snapshot.ref.getDownloadURL();
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(firebaseUser.uid.toString())
              .update({"profile_image": _imageURL});
        } catch (e) {
          print("Error updating document: $e");
        }
        setState(() {});
      } catch (error) {
        print("Error uploading image: $error");
        return null;
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return Container(
              color: const Color.fromARGB(100, 22, 44, 33),
              child: AlertDialog(
                title: const Text("Error"),
                content: const Text("Image size exceeding 2mb."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              ),
            );
          });
    }
  }
}
