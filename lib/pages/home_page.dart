import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/components/app_drawer.dart';
import 'package:social_media_app/components/app_list_tile.dart';
import 'package:social_media_app/components/custom_button.dart';
import 'package:social_media_app/components/user_text_field.dart';
import 'package:social_media_app/database/firebase.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  // Firestore Access
  final FirestoreDatabase database = FirestoreDatabase();

  // Text Controller
  final TextEditingController newPostController = TextEditingController();

  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);

      newPostController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "W A L L",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Text Field
                Expanded(
                  child: UserTextfield(
                    hintText: "SAY SOMETHING ..",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),

                // Post Button
                CustomButton(onTap: postMessage),
              ],
            ),
          ),

          StreamBuilder(
            stream: database.getPostsSteam(),
            builder: (context, snapshot) {
              // Show Loading Circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              // Get all posts
              final posts = snapshot.data!.docs;

              // No Data?
              if (snapshot.data == null || posts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      "No posts... Post something!",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }

              // Return as a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // Get each Individual Post
                    final post = posts[index];

                    // Get Data From Each Post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];
                    Timestamp timestamp = post['TimeStamp'];

                    return AppListTile(title: message, subtitle: userEmail);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
