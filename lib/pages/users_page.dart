import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/helper/helper_functions.dart';

import '../components/back_button.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // Any Errors
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          // Show Loading Circle
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const Text("No Data");
          }

          // Get all users
          final users = snapshot.data!.docs;

          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0, left: 25.0),
                child: Row(children: [CustomBackButton()]),
              ),
              const SizedBox(height: 25),

              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.only(left: 15.0),
                  itemBuilder: (context, index) {
                    // Get Individual Users
                    final user = users[index];

                    return ListTile(
                      title: Text(
                        user['email'],
                        style: const TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        user['username'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
