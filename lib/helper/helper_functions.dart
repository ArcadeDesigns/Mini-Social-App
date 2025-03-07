import 'package:flutter/material.dart';

// Display Error Message to User
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
  );
}
