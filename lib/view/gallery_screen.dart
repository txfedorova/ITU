import 'dart:convert'; // For JSON

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> imageNames = ['Forrest_Gump.jpg', 'Kolija.jpg'];
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: PageView.builder(
        itemCount: imageNames.length,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController!,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController?.position.haveDimensions ?? false) {
                value = _pageController!.page! - index;
                value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) *
                      MediaQuery.of(context).size.height,
                  width: Curves.easeInOut.transform(value) *
                      MediaQuery.of(context).size.width,
                  child: child,
                ),
              );
            },
            child: Image.asset('images/${imageNames[index]}'),
          );
        },
      ),
    );
  }

  // Doesn't work because AssetManifest.json doesn't exist
  // Upd: it is generated only after building the release apk
  // https://stackoverflow.com/questions/56544200/flutter-how-to-get-a-list-of-names-of-all-images-in-assets-directory
  // https://stackoverflow.com/questions/54692052/display-all-images-in-a-directory-to-a-list-in-flutter
  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
  
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('.svg'))
        .toList();

    print(imagePaths);
  
    setState(() {
      imageNames = imagePaths;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}