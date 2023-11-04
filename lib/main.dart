import 'package:flutter/material.dart';
import 'package:itu_app/view/gallery_screen.dart';
import 'package:itu_app/view/film_edit_screen.dart';
import 'package:itu_app/view/films_list_screen.dart';
import 'package:itu_app/view/home_screen.dart';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'package:itu_app/controller/film_controller.dart';

void main() {
  setupWindow();
  runApp(ChangeNotifierProvider(
    create: (context) => FilmController(),
    child: const MyApp()
  ));
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
    return MaterialApp.router(
      title: "Title",
      routerConfig: router(),
      debugShowCheckedModeBanner: false,
       theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF59B773),
          secondary: const Color(0xFF59B773),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6FAF1),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
    );
  }   
}
