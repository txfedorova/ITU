import 'package:flutter/material.dart';
import 'custom_bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: getCurrentScreen(navBarIndex),
        bottomNavigationBar: CustomBottomNavigationBar(
          onIndexChanged: (int index) {
            setState(() {
              navBarIndex = index;
            });
            // Handle index change here
            // You can update the state or navigate to a different screen based on the index
          },
        ),
      ),
    );
  }

  Widget getCurrentScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SettingsScreen();
      default:
        return Container(); // Return a default screen or handle error case
    }
  }
}




