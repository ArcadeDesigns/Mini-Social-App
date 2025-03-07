/*

This database stored posts that users have published in the app. It is stored in a collection called 'Posts' in firebase.

Each Post Container;
- A message
- Email of user
- Timestamp

 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  // Current Logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // Get Collection of Posts from Firebase
  final CollectionReference posts = FirebaseFirestore.instance.collection(
    'Posts',
  );

  // Post a Message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

  // Read posts from database
  Stream<QuerySnapshot> getPostsSteam() {
    final postsStream =
        FirebaseFirestore.instance
            .collection('Posts')
            .orderBy('TimeStamp', descending: true)
            .snapshots();

    return postsStream;
  }
}
