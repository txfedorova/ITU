import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itu_app/view/user_input.dart';
import 'package:itu_app/model/db_helper.dart'; // Import the DatabaseHelper

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('CineMatch'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User input section with scrolling
              Expanded(
                child: ListView(
                  children: [
                    UserInputWidget(
                      // onUserAdded: () {
                      //   // Callback function to navigate to film gallery screen
                      //   context.push('/filmGallery');
                      // },
                      onUserSelected: (userId) {
                        // Callback function to navigate to film gallery with selected user's ID
                        context.push('/filmGallery/$userId');
                      },
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                child: const Text('View results'),
                onPressed: () {
                  context.push('/statsScreen');
                },
              ),
              // Button to delete the database
              ElevatedButton(
                child: const Text('Delete Database'),
                onPressed: () async {
                  await _deleteDatabase(context);
                },
              ),

              // Buttons at the bottom
              ElevatedButton(
                child: const Text('Next User'),
                onPressed: () {
                  context.push('/filmGallery');
                },
              ),
              ElevatedButton(
                child: const Text('List films'),
                onPressed: () {
                  context.push('/listFilms');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to delete the database
  Future<void> _deleteDatabase(BuildContext context) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.clearDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Database deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting database: $e'),
        ),
      );
    }
  }
}
