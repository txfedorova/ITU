import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itu_app/model/user_input.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF59B773),
        title: const Text('CineMatch'),
      ),
      body: Center(
        child: Container(
          color: const Color(0xFFF6FAF1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User input section with scrolling
              Expanded(
                child: ListView(
                  //shrinkWrap: true,
                  children: [
                    // Include the UserInputWidget here
                    UserInputWidget(), // This is the user input section
                  ],
                ),
              ),

              // Spacer to separate the user input section from the buttons
              //Spacer(),

              // Buttons at the bottom
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59B773),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Next User'),
                onPressed: () {
                  context.push('/filmGallery');
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF59B773),
                  foregroundColor: Colors.white,
                ),
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
}