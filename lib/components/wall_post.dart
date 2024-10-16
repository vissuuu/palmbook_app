import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:palmbook_ios/components/ReportButton.dart';
import 'package:palmbook_ios/components/comment_button.dart';
import 'package:palmbook_ios/components/delete_button.dart';
import 'package:palmbook_ios/components/like_button.dart';
import 'package:palmbook_ios/components/comment.dart';
import 'package:palmbook_ios/helper/helper.dart';
import 'package:intl/intl.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;
  final String email;
  final String uid;
  final bool report;
  final bool visibility;
  final int commentCount;

  final String? imageUrl;

  final String category;
  const WallPost({super.key, required this.message, required this.user, required this.likes, required this.postId, required this.time, required this.email, required this.uid, this.imageUrl, required this.category, required this.report, required this.visibility, required this.commentCount});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool showComments = false;
  bool showFullMessage = false;
  bool isDeleting = false;
  bool isReported = false;

  final _commentTextController = TextEditingController();

  Future<String> name() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String uid = currentUser.uid;
        String name = await getData(uid);
        return name;
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
        String pro = await getpro(uid);
        return pro;
      } else {
        print('User not logged in.');
        return '';
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  String pro = '';
  Future<String> profile_image() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        pro = await getpro(widget.uid);
        return pro;
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
        String fieldValue = documentSnapshot.get('Name');
        return fieldValue;
      } else {
        print('Document does not exist');
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }

  Future<String> getpro(String uid) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      DocumentReference documentRef = users.doc(uid);
      DocumentSnapshot documentSnapshot = await documentRef.get();

      if (documentSnapshot.exists) {
        String fieldValue = documentSnapshot.get('profile_image');
        return fieldValue;
      } else {
        print('Document does not exist');
        return '';
      }
    } catch (e) {
      print('Error getting document: $e');
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLiked(); // Check if the post is liked by the current user
    fetchUserProfile();
  }

  void checkIfLiked() {
    // Ensure that the isLiked state is set based on the current user's email and the likes list
    setState(() {
      isLiked = widget.likes.contains(currentUser.email);
    });
  }

  String? userProfileImageUrl;

  Future<String> fetchUserProfile() async {
    try {
      // Fetch the user's profile image dynamically using the existing prof() function
      return await getpro(widget.uid);
    } catch (e) {
      print("Error fetching user profile: $e");
      return '';
    }
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef = FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId);
    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([
          currentUser.email
        ])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([
          currentUser.email
        ])
      });
    }
  }

  // Future<void> addComment(String commentText) async {
  //   String userName = await name();
  //   String profile = await prof();
  //   FirebaseFirestore.instance
  //       .collection("UserPosts")
  //       .doc(widget.postId)
  //       .collection("Comments")
  //       .add({
  //     "CommentText": commentText,
  //     "CommentBy": userName,
  //     "CommentTime": Timestamp.now(),
  //     "profile": profile,
  //   });
  // //   await FirebaseFirestore.instance
  // //       .collection("UserPosts")
  // //       .doc(widget.postId).update({
  // //     "commentCount": FieldValue.increment(1), // Increment comment count by 1
  // //   });
  // // }

  Future<void> addComment(String commentText) async {
    String userName = await name();
    String profile = await prof();
    FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).collection("Comments").add({
      "CommentText": commentText,
      "CommentBy": userName,
      "CommentTime": Timestamp.now(),
      "profile": profile,
    });
    await FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).update({
      "commentCount": FieldValue.increment(1), // Increment comment count by 1
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: SizedBox(
          width: 300, // Set the desired width here
          child: TextField(
            controller: _commentTextController,
            decoration: const InputDecoration(hintText: "Write a comment.."),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentTextController.clear();
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                if (_commentTextController.text.trim().isEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cannot post an empty comment"),
                    ),
                  );
                } else {
                  // Post the comment if it's not empty
                  addComment(_commentTextController.text).then((_) {
                    Navigator.pop(context); // Close the dialog after posting
                    _commentTextController.clear(); // Clear the text field
                  });
                }
              },
              child: const Text("Post")),
        ],
      ),
    );
  }

  void deletePost() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this post? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog and proceed with deletion

                setState(() {
                  isDeleting = true; // Show loading indicator
                });

                try {
                  // Delete comments first
                  final commentDocs = await FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).collection("Comments").get();

                  for (var doc in commentDocs.docs) {
                    await FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).collection("Comments").doc(doc.id).delete();
                  }

                  // Delete the post itself
                  await FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).delete();

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Post deleted successfully")),
                  );
                } catch (error) {
                  print("Failed to delete post: $error");
                  // Optionally, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete post")),
                  );
                }

                if (mounted) {
                  setState(() {
                    isDeleting = false;
                  });
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void reportPost() {
    if (!widget.report) {
      DocumentReference postRef = FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId);

      postRef.update({
        'report': true
      }).then((_) {
        // Optionally show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post reported successfully")),
        );
      }).catchError((error) {
        print("Failed to report post: $error");
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to report post")),
        );
      });
    } else {
      // If post is already reported, you may want to inform the user or remove the report
      DocumentReference postRef = FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId);

      postRef.update({
        'report': false
      }).then((_) {
        // Optionally show a message that the report was removed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post report removed")),
        );
      }).catchError((error) {
        print("Failed to remove report: $error");
        // Optionally show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to remove report")),
        );
      });
    }
  }

  void showFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullImageScreen(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    isLiked = widget.likes.contains(currentUser.email);

    if (isDeleting) {
      return const Center(
        child: CircularProgressIndicator(), // Display loader while deleting
      );
    }

    String username = widget.user;

    String getInitials(String username) {
      List<String> parts = username.split(' ');

      String initials = parts.map((part) => part.isNotEmpty ? part[0].toUpperCase() : '').join('');

      return initials;
    }

    String initials = getInitials(username);

    String _generateAvatarUrl(String initials) {
      final encodedInitials = Uri.encodeComponent(initials);
      return 'https://ui-avatars.com/api/?name=$initials&background=random&color=fff&bold=true';
    }

    final avatarUrl = _generateAvatarUrl(initials);

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF979797).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FutureBuilder<String>(
                        future: fetchUserProfile(), // Fetch profile image dynamically
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircleAvatar(
                              radius: width * .06,
                              backgroundColor: const Color(0xFF7785FC),
                              child: const CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                            return CircleAvatar(
                              radius: width * .06,
                              backgroundImage: NetworkImage(avatarUrl), // Fallback image
                            );
                          } else {
                            return CircleAvatar(
                              radius: width * .06,
                              backgroundImage: NetworkImage(snapshot.data!),
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            widget.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Category: ${widget.category}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (widget.email == currentUser.email) DeleteButton(onTap: deletePost) else if (widget.email != currentUser.email) ReportButton(onTap: reportPost, report: widget.report)
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: widget.message.length > 300
                        ? () {
                            setState(() {
                              showFullMessage = !showFullMessage;
                            });
                          }
                        : null,
                    child: Text(
                      widget.message.length <= 300 ? widget.message : (showFullMessage ? widget.message : widget.message.substring(0, 300) + '...'),
                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  if (widget.message.length > 300)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showFullMessage = !showFullMessage;
                        });
                      },
                      child: Text(
                        showFullMessage ? '\nRead less' : 'Read more',
                        style: const TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  if (widget.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: GestureDetector(
                        onTap: () => showFullImage(widget.imageUrl!),
                        child: Hero(
                          tag: widget.imageUrl!,
                          child: SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Row(
            //     children: [
            //       LikeButton(isLiked: isLiked, onTap: toggleLike),
            //       SizedBox(width: 5),
            //       Text(
            //         widget.likes.length.toString(),
            //         style: TextStyle(color: Colors.grey, fontSize: 12),
            //       ),
            //       SizedBox(width: 15),
            //       Container(
            //         width: width *0.7,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             CommentButton(onTap: showCommentDialog, postId: widget.postId,),
            //             if(widget.commentCount>0)
            //               TextButton(
            //                 onPressed: () {
            //                   setState(() {
            //                     showComments = !showComments;
            //                   });
            //                 },
            //                 child: Text(
            //                   (showComments) ? "Hide Comments ${widget.commentCount}" : "Show Comments",
            //                   style: TextStyle(color: Colors.grey, fontSize: 12),
            //                 ),
            //               ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  const SizedBox(width: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommentButton(onTap: showCommentDialog, postId: widget.postId),
                        if (widget.commentCount > 0)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showComments = !showComments;
                              });
                            },
                            child: Text(
                              showComments ? "Hide Comments " : "Show Comments ",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // if (showComments && widget.commentCount == 0)
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //             child: StreamBuilder<QuerySnapshot>(
            //               stream: FirebaseFirestore.instance
            //                   .collection("UserPosts")
            //                   .doc(widget.postId)
            //                   .collection("Comments")
            //                   .orderBy("CommentTime", descending: true)
            //                   .snapshots(),
            //               builder: (context, snapshot) {
            //                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            //                   return SizedBox.shrink(); // Hide the comment section if no comments
            //                 }
            //                 return ListView(
            //                   shrinkWrap: true,
            //                   physics: NeverScrollableScrollPhysics(),
            //                   children: snapshot.data!.docs.map((doc) {
            //                     final commentData = doc.data() as Map<String, dynamic>;
            //                     return Comment(
            //                       user: commentData["CommentBy"],
            //
            //                       // time: formatDate(commentData["CommentTime"]),
            //                       time: DateFormat('d MMMM yyyy, hh:mma').format(commentData["CommentTime"].toDate()),
            //                       text: commentData["CommentText"],
            //                       // profile: commentData["profile"],
            //                     );
            //                   }).toList(),
            //                 );
            //               },
            //             ),
            //           ),
            //         SizedBox(height: 10),
            //       ],
            //     ),
            //   ),
//
//     );
//   }
// }
            if (showComments)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("UserPosts").doc(widget.postId).collection("Comments").orderBy("CommentTime", descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        final commentData = doc.data() as Map<String, dynamic>;
                        return Comment(
                          user: commentData["CommentBy"],

                          // time: formatDate(commentData["CommentTime"]),
                          time: DateFormat('d MMMM yyyy, hh:mma').format(commentData["CommentTime"].toDate()),
                          text: commentData["CommentText"],
                          // profile: commentData["profile"],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // GestureDetector that covers the background
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent, // Set the background color as transparent
            ),
          ),
          // Center the image with zoom and pan functionality
          Center(
            child: Hero(
              tag: imageUrl,
              child: InteractiveViewer(
                panEnabled: true, // Allow panning
                minScale: 0.5, // Minimum zoom scale
                maxScale: 4.0, // Maximum zoom scale
                child: Image.network(imageUrl),
              ),
            ),
          ),
          Positioned(
            top: 40.0, // Adjust this value as needed
            left: 10.0, // Adjust this value as needed
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
