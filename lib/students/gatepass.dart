// ignore_for_file: use_build_context_synchronously
import 'dart:io' if (dart.library.win32) 'package:win32/win32.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:palmbook_ios/logics/utils.dart';
import 'package:uuid/uuid.dart';

class gatepass_request extends StatefulWidget {
  const gatepass_request({Key? key}) : super(key: key);

  @override
  State<gatepass_request> createState() => gatepass_requestState();
}

class gatepass_requestState extends State<gatepass_request> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime? outDateTime;
  DateTime? returnDateTime;
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  String reason = '';
  String parentphone = '';
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _dateTimeController2 = TextEditingController();

  Future<void> _selectOutDateTime() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          outDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _dateTimeController.text =
              DateFormat('d MMMM yyyy, h:mm a').format(outDateTime!);
        });
      }
    }
  }

  Future<void> _selectReturnDateTime() async {
    if (outDateTime == null) {
      Utils.showSnackBar("Please select Out Date and Time first.");
      return;
    }

    DateTime initialDate = outDateTime!.add(const Duration(days: 1));
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          returnDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _dateTimeController2.text =
              DateFormat('d MMMM yyyy, h:mm a').format(returnDateTime!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7785FC),
        elevation: 0,
        title: Text(
          "Create Gatepass",
          style: GoogleFonts.poppins(
              textStyle: const TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w600,
          )),
        ),
        toolbarHeight: 62,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _dateTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Out Date and Time*',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF9B9B9B), width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    onTap: _selectOutDateTime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date and time.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _dateTimeController2,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Return Date and Time*',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF9B9B9B), width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    onTap: _selectReturnDateTime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date and time.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: 'Reason*',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF9B9B9B), width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter reason.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      reason = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Parent's phone number*",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: Color(0xFF9B9B9B), width: 0.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: .5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: .5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter parent's phone number.";
                      }
                      // Simple regex for validating phone numbers (10 digits)
                      final RegExp phoneRegExp = RegExp(r'^[6-9][0-9]{9}$');
                      if (!phoneRegExp.hasMatch(value)) {
                        // return "Please enter valid phone number.";
                        // Show snackbar if the phone number is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enter a valid phone number')),
                        );
                        return null; // Return null to prevent form submission
                      }
                      return null; // Valid phone number
                    },
                    onSaved: (value) {
                      parentphone = value!;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: _selectImage,
                    child: const Text('Select Image*'),
                  ),
                  const SizedBox(height: 5.0),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      height: 200.0, // Adjusted height for better UI
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate() != null) {
                        _formKey.currentState!.save();
                        _createslot();
                      }
                    },
                    child: Container(
                      width: width,
                      height: 55,
                      decoration: BoxDecoration(
                          color: const Color(0xff7785FC),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//   // Future<void> _createslot() async {
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (context) {
//   //       return const Center(child: CircularProgressIndicator());
//   //     },
//   //   );
//   //
//   //   String ID = Uuid().v4(); // Use Uuid to generate a random ID
//   //   final currentUser = FirebaseAuth.instance.currentUser;
//   //   String uid = currentUser!.uid;
//   //   Map<String, dynamic>? userInfo = await getUserInfo(uid);
//   //   String? hostel = userInfo?['Hostel'] as String?;
//   //   String? name = userInfo?['Name'] as String?;
//   //   String? _imageURL = await uploadImageToFirebase(_selectedImage!, ID);
//   //
//   //   try {
//   //     CollectionReference<Map<String, dynamic>> collectionReference =
//   //     FirebaseFirestore.instance.collection('Gatepass');
//   //     DocumentReference<Map<String, dynamic>> newDocumentRef =
//   //     collectionReference.doc(ID);
//   //
//   //     await newDocumentRef.set({
//   //       'name': name,
//   //       'request_id': ID,
//   //       'start': outDateTime,
//   //       'end': returnDateTime,
//   //       'reason': reason,
//   //       'parent_phone': parentphone,
//   //       'status': 'Submitted',
//   //       'uid': uid,
//   //       'hostel': hostel,
//   //       'screenshot': _imageURL,
//   //       'application time' : DateTime.now(),
//   //       'warden update time' : '',
//   //       'exit time' : '',
//   //       'return time' : '',
//   //     });
//   //
//   //     Utils.showSnackBar(
//   //       "Request Submitted",
//   //     );
//   //     Navigator.pop(context);
//   //     Navigator.pop(context);
//   //
//   //     // Document creation successful
//   //     print('Document created with ID: ${newDocumentRef.id}');
//   //   } catch (e) {
//   //     // Handle errors
//   //     print('Error creating document: $e');
//   //   }
//   // }hell0

  Future<void> _createslot() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Additional validation
    if (outDateTime == null ||
        returnDateTime == null ||
        reason.isEmpty ||
        parentphone.isEmpty ||
        _selectedImage == null) {
      Navigator.pop(context); // Close loading dialog
      Utils.showSnackBar(
        "Please fill in all required fields.",
      );
      return; // Stop further execution
    }

    // Ensure phone number is exactly 10 digits
    if (parentphone.length != 10) {
      Navigator.pop(context); // Close loading dialog
      Utils.showSnackBar(
        "Parent's phone number must be exactly 10 digits.",
      );
      return;
    }

    // Ensure return date is after out date
    if (returnDateTime!.isBefore(outDateTime!)) {
      Navigator.pop(context); // Close loading dialog
      Utils.showSnackBar(
        "Return date and time must be after the out date and time.",
      );
      return;
    }

    // Get user information
    String ID = const Uuid().v4(); // Generate random ID
    final currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser!.uid;
    Map<String, dynamic>? userInfo = await getUserInfo(uid);
    String? hostel = userInfo?['Hostel'] as String?;
    String? name = userInfo?['Name'] as String?;
    String? _imageURL = await uploadImageToFirebase(_selectedImage!, ID);

    // Validate if required fields are not empty
    if (name == "" ||
        hostel == null ||
        hostel.isEmpty ||
        _imageURL == null ||
        _imageURL.isEmpty) {
      Navigator.pop(context); // Close loading dialog
      Utils.showSnackBar(
        "Please fill in all required fields.",
      );
      return;
    }

    try {
      CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection('Gatepass');
      DocumentReference<Map<String, dynamic>> newDocumentRef =
          collectionReference.doc(ID);

      // Create the document in Firestore
      await newDocumentRef.set({
        'name': name,
        'request_id': ID,
        'start': outDateTime,
        'end': returnDateTime,
        'reason': reason,
        'parent_phone': parentphone,
        'status': 'Submitted',
        'uid': uid,
        'hostel': hostel,
        'screenshot': _imageURL,
        'application_time': DateTime.now(),
        'warden_update_time': '',
        'exit_time': '',
        'return_time': '',
      });

      // Success notification and navigation
      Navigator.pop(context); // Close the progress dialog
      Utils.showSnackBar(
        "Request Submitted",
      );
      Navigator.pop(context); // Navigate back to previous screen

      // Document creation successful
      print('Document created with ID: ${newDocumentRef.id}');
    } catch (e) {
      // Handle errors
      Navigator.pop(context); // Close the loading dialog if an error occurs
      print('Error creating document: $e');
      Utils.showSnackBar(
        "An error occurred while submitting your request.",
      );
    }
  }

  // Future<void> _createslot() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   );
  //   String ID = await getid();
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   String uid = currentUser!.uid;
  //   Map<String, dynamic>? userInfo = await getUserInfo(uid);
  //   String? hostel = userInfo?['Hostel'] as String?;
  //   String? name = userInfo?['Name'] as String?;
  //   String? _imageURL = await uploadImageToFirebase(_selectedImage!, ID);
  //   try {
  //     CollectionReference<Map<String, dynamic>> collectionReference =
  //     FirebaseFirestore.instance.collection('Gatepass');
  //     DocumentReference<Map<String, dynamic>> newDocumentRef = collectionReference.doc(ID);
  //     await newDocumentRef.set({
  //       'name' : name,
  //       'request_id' : ID,
  //       'start' : outDateTime,
  //       'end' : returnDateTime,
  //       'reason' : reason,
  //       'parent_phone' : parentphone,
  //       'status' : 'Submitted',
  //       'uid' : uid,
  //       'hostel' : hostel,
  //       'screenshot' : _imageURL
  //     });
  //     Utils.showSnackBar(
  //       "Request Submitted",
  //     );
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //
  //     // Document creation successful
  //     print('Document created with ID: ${newDocumentRef.id}');
  //   } catch (e) {
  //     // Handle errors
  //     print('Error creating document: $e');
  //   }
  // }
  //
  // static getid() async {
  //   final collectionRef = FirebaseFirestore.instance.collection('Gatepass');
  //   final snapshot = await collectionRef.get();
  //   final documents = snapshot.docs;
  //   final ticketIds = [];
  //   for (final doc in documents) {
  //     ticketIds.add(doc.id.toString());
  //   }
  //   int i = ticketIds.length-1;
  //   int newTicketId = int.parse(ticketIds[i].toString())+1;
  //   return newTicketId.toString();
  // }

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();

      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user document: $e");
      return null;
    }
  }

//   Future<void> _outDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );

//       if (pickedTime != null) {
//         outDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );

//         setState(() {
//           _dateTimeController.text = outDateTime.toString();
//         });
//       }
//     }
//   }

//   Future<void> _returnDateTime() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.now(),
//       );

//       if (pickedTime != null) {
//         returnDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );

//         setState(() {
//           _dateTimeController2.text = returnDateTime.toString();
//         });
//       }
//     }
//   }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (await pickedFile.length() <= 4194304) {
        // 4MB limit
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("Image size exceeding 4MB."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Ok"))
                ],
              );
            });
      }
    }
  }

  Future<String?> uploadImageToFirebase(File imageFile, String fileName) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child("gatepass_mails/$fileName.jpg");

      // Set content type to image/jpeg
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      UploadTask uploadTask = storageReference.putFile(
        imageFile,
        metadata,
      );

      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image.
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print("Error uploading image: $error");
      Utils.showSnackBar("Error uploading image.");
      return null;
    }
  }
}
