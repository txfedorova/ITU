import 'package:flutter/material.dart';
import 'package:itu_app/view/gallery_screen.dart';
import 'package:itu_app/view/film_edit_screen.dart';
import 'package:itu_app/view/films_list_screen.dart';
import 'package:itu_app/common/custom_bottom_navigation_bar.dart';
import 'package:itu_app/view/home_screen.dart';
import 'package:itu_app/view/settings_screen.dart';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'package:itu_app/controller/film_controller.dart';

void main() {
  setupWindow();
  runApp(const MyApp());
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Demo');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/homeScreen',
    routes: [
      GoRoute(
        path: '/homeScreen',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/filmGallery',
        builder: (context, state) => GalleryScreen(),
       
      ),
      GoRoute(
        path: '/editScreen',
        builder: (context, state) => FilmEditScreen(),
      ),
      GoRoute(
        path: '/listFilms',
        builder: (context, state) => FilmsList(),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FilmController(),
      child: MaterialApp.router(
        title: "Title",
        routerConfig: router(),
        debugShowCheckedModeBanner: false,
      ),
    );

    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Scaffold(
    //     body: getCurrentScreen(navBarIndex),
    //     bottomNavigationBar: CustomBottomNavigationBar(
    //       onIndexChanged: (int index) {
    //         setState(() {
    //           navBarIndex = index;
    //         });
    //         // Handle index change here
    //         // You can update the state or navigate to a different screen based on the index
    //       },
    //     ),
    //   ),
    // );
  }

  // Widget getCurrentScreen(int index) {
  //   switch (index) {
  //     case 0:
  //       return const HomeScreen();
  //     case 1:
  //       return const SettingsScreen();
  //     default:
  //       return Container(); // Return a default screen or handle error case
  //   }
  // }
}

