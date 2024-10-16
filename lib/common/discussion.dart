import 'dart:ffi';
import 'dart:io' if (dart.library.win32) 'package:win32/win32.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palmbook_ios/components/wall_post.dart';
import 'package:palmbook_ios/helper/helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class test3 extends StatefulWidget {
  const test3({super.key});

  @override
  State<test3> createState() => _test3State();
}

Future<String> name() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Assuming getData returns a Future<String>
      String name = await getData(uid);
      return name;
      print('Name: $name');
    } else {
      print('User not logged in.');
      return '';
    }
  } catch (e) {
    print('Error: $e');
    return '';
  }
}

Future<String> prof() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;

      // Assuming getData returns a Future<String>
      String pro = await getpro(uid);
      return pro;
      print('Name: $pro');
    } else {
      print('User not logged in.');
      return '';
    }
  } catch (e) {
    print('Error: $e');
    return '';
  }
}

Future<String> getData(String uid) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    DocumentReference documentRef = users.doc(uid);

    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      // Replace 'fieldName' with the actual field name you want to retrieve as a string
      String fieldValue = documentSnapshot.get('Name');
      return fieldValue;
    } else {
      print('Document does not exist');
      return ''; // or handle the absence of data in another way
    }
  } catch (e) {
    print('Error getting document: $e');
    return ''; // or handle the error in another way
  }
}

Future<String> getuid() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      return uid;
    } else {
      // print('User not logged in.');
      return '';
    }
  } catch (e) {
    // print('Error: $e');
    return '';
  }
}

Future<String> getpro(String uid) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    DocumentReference documentRef = users.doc(uid);

    DocumentSnapshot documentSnapshot = await documentRef.get();

    if (documentSnapshot.exists) {
      // Replace 'fieldName' with the actual field name you want to retrieve as a string
      String fieldValue = documentSnapshot.get('profile_image');
      return fieldValue;
    } else {
      print('Document does not exist');
      return ''; // or handle the absence of data in another way
    }
  } catch (e) {
    print('Error getting document: $e');
    return ''; // or handle the error in another way
  }
}

class _test3State extends State<test3> {
  final textController = TextEditingController();

  //
  // void postmessage(String message) async {
  //   String userName = await name();
  //   String profile = await prof();
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //
  //
  //   if (userName.isNotEmpty && message.isNotEmpty) {
  //     FirebaseFirestore.instance.collection("UserPosts").add({
  //       'User': userName,
  //       'Message': message,
  //       'TimeStamp': Timestamp.now(),
  //       'Likes': [],
  //       'email': currentUser?.email,
  //       'profile': profile,
  //       'report':false,
  //       'visibility':true,
  //       'commentCount':0,
  //     });
  //   }
  // }
  void postmessage(BuildContext context, String message) async {
    String userName = await name();
    String profile = await prof();
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the message is empty
    if (message == "") {
      // Show dialog box if the message is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text("Can't create post. Message cannot be empty."),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function
    }

    if (userName.isNotEmpty && message.isNotEmpty) {
      FirebaseFirestore.instance.collection("UserPosts").add({
        'User': userName,
        'Message': message,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'email': currentUser?.email,
        'profile': profile,
        'report': false,
        'visibility': true,
        'commentCount': 0,
      });
    }
  }

  String showMenu = "All"; // Default is "All"
  Widget buildFilterButton(String category) {
    bool isSelected = showMenu == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            showMenu = category;
          });
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          height: 30,
          width: 50,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7785FC) : Colors.white,
            border: Border.all(color: const Color(0xFF7785FC)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF7785FC),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7785FC),
        elevation: 0,
        title: Text(
          "Community",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
          )),
        ),
        toolbarHeight: 62,
        centerTitle: true,
        // leading: IconButton(
        //   icon: Image.asset("assets/icons/menu.png"), // set your color here
        //   onPressed: () {
        //     scafoldKey.currentState.openDrawer();
        //   },
        // ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),

        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: 15, bottom: 15),
              child: Row(
                children: [
                  SizedBox(
                    width: 50, // Set the width of the button here
                    child: buildFilterButton("All"),
                  ),
                  SizedBox(
                    width: 80, // Set the width of the button here
                    child: buildFilterButton("General"),
                  ),
                  SizedBox(
                    width: 80, // Set the width of the button here
                    child: buildFilterButton("Events"),
                  ),
                  SizedBox(
                    width: 110, // Set the width of the button here
                    child: buildFilterButton("Complaints"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("UserPosts")
                    .orderBy("TimeStamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var posts = snapshot.data!.docs;
                    if (showMenu != "All") {
                      posts = posts
                          .where((post) => post['Category'] == showMenu)
                          .toList();
                    }
                    // return ListView.builder(
                    //   itemCount: posts.length,
                    //   itemBuilder: (context, index) {
                    //     final post = posts[index];
                    //     return WallPost(
                    //       message: post['Message'],
                    //       user: post['User'],
                    //       postId: post.id,
                    //       likes: List<String>.from(post['Likes'] ?? []),
                    //       time: DateFormat('d MMMM yyyy, hh:mma').format(post['TimeStamp'].toDate()),
                    //       email: post['email'],
                    //       visibility: post['visibility'],
                    //       report: post['report'],
                    //
                    //       uid: post['uid'],
                    //       imageUrl: post['ImageUrl'],
                    //       category: post['Category'],
                    //     // Pass the category
                    //     );
                    //   },
                    // );
                    // return ListView.builder(
                    //   itemCount: posts.length,
                    //   itemBuilder: (context, index) {
                    //     final post = posts[index];
                    //     return WallPost(
                    //       message: post['Message'],
                    //       user: post['User'],
                    //       postId: post.id,
                    //       likes: List<String>.from(post['Likes'] ?? []),
                    //       time: DateFormat('d MMMM yyyy, hh:mma').format(post['TimeStamp'].toDate()),
                    //       email: post['email'],
                    //       visibility: post['visibility'],
                    //       report: post['report'],
                    //       uid: post['uid'],
                    //       imageUrl: post['ImageUrl'],
                    //       category: post['Category'],
                    //       commentCount:post['commentCount']
                    //
                    //     );
                    //   },
                    // );

                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        // Check if the visibility is true
                        if (post['visibility'] == true) {
                          return WallPost(
                            message: post['Message'],
                            user: post['User'],
                            postId: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            time: DateFormat('d MMMM yyyy, hh:mma')
                                .format(post['TimeStamp'].toDate()),
                            email: post['email'],
                            visibility: post['visibility'],
                            report: post['report'],
                            uid: post['uid'],
                            imageUrl: post['ImageUrl'],
                            category: post['Category'],
                            commentCount: post['commentCount'],
                          );
                        } else {
                          // Return an empty container or handle non-visible posts as needed
                          return SizedBox.shrink();
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error' + snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPostScreen()),
            );
            // .then((message) {
            //   if (message != null) {
            //     postmessage(context, message);
            //   } else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text("Cannot create an empty post"),
            //       ),
            //     );
            //   }
            // });
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF7785FC),
      ),
    );
  }
}

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final textController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  bool isLoading = false;
  // Define the list of categories
  String selectedCategory = 'General';
  final List<String> categories = ['General', 'Events', 'Complaints'];
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child(DateTime.now().toString() + '.jpg');

      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> postMessage(String message, String? imageUrl) async {
    String userName = await name();

    String uid = await getuid();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (userName.isNotEmpty && message.isNotEmpty) {
      FirebaseFirestore.instance.collection("UserPosts").add({
        'User': userName,
        'Message': message,
        'ImageUrl': imageUrl,
        'uid': uid,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'email': currentUser?.email,
        'report': false,
        'visibility': true,
        // 'profile': profile,
        'Category': selectedCategory,
        'commentCount': 0 // Add category to the post
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
          )),
        ),
        toolbarHeight: 62,
        centerTitle: true,
        // leading: IconButton(
        //   icon: Image.asset("assets/icons/menu.png"), // set your color here
        //   onPressed: () {
        //     scafoldKey.currentState.openDrawer();
        //   },
        // ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),

        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF7785FC),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Write something on the wall...',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color(0xFF7785FC), // Set your desired background color
                ),
                child: Text(
                  'Pick Image',
                  style:
                      TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
              SizedBox(height: 16),
              _image != null ? Image.file(_image!) : Container(),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items:
                    categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cannot create an empty post"),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });

                  String? imageUrl;
                  if (_image != null) {
                    imageUrl = await uploadImage(_image!);
                  }
                  await postMessage(textController.text, imageUrl);

                  setState(() {
                    isLoading = false;
                  });

                  if (!(textController.text.trim().isEmpty)) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF7785FC), // Custom background color
                ),
                child: Text(
                  "Post",
                  style:
                      TextStyle(color: Colors.white), // Text color set to white
                ),
              ),
              SizedBox(height: 16),
              if (isLoading) Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
