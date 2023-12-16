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
        backgroundColor: const Color.fromARGB(255, 68, 70, 115),
        foregroundColor: Colors.white,
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
                child: const Text(
                  'View results',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  context.push('/statsScreen');
                },
              ),
              const SizedBox(height: 20),

              // Buttons at the bottom
              ElevatedButton(
                child: const Text(
                  'List of films',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  context.push('/listFilms');
                },
              ),
              const SizedBox(height: 20),
              // Button to delete the database
              // ElevatedButton(
              //   child: const Text(
              //     'Delete Database',
              //     style: TextStyle(fontSize: 20),
              //   ),
              //   onPressed: () async {
              //     await _deleteDatabase(context);
              //   },
              // ),
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
