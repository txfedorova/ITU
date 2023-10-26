import 'package:flutter/material.dart';
import 'package:itu_app/swipe_image_gallery.dart';
import 'package:itu_app/view/edit_screen.dart';
import 'package:itu_app/view/list_films.dart';
import 'custom_bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'package:itu_app/model/films.dart';

void main() => runApp(MyApp());

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
        builder: (context, state) => SwipeImageGallery(),
        // routes: [
        //   GoRoute(
        //     path: 'cart',
        //     builder: (context, state) => const MyCart(),
        //   ),
        // ],
      ),
      GoRoute(
        path: '/editScreen',
        builder: (context, state) => EditScreen(),
      ),
      GoRoute(
        path: '/listFilms',
        builder: (context, state) => ListFilms(),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // State<MyApp> createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FilmsModel(),
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

// class _MyAppState extends State<MyApp> {
//   int navBarIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: getCurrentScreen(navBarIndex),
//         bottomNavigationBar: CustomBottomNavigationBar(
//           onIndexChanged: (int index) {
//             setState(() {
//               navBarIndex = index;
//             });
//             // Handle index change here
//             // You can update the state or navigate to a different screen based on the index
//           },
//         ),
//       ),
//     );
//   }

//   Widget getCurrentScreen(int index) {
//     switch (index) {
//       case 0:
//         return const HomeScreen();
//       case 1:
//         return const SettingsScreen();
//       default:
//         return Container(); // Return a default screen or handle error case
//     }
//   }
// }




