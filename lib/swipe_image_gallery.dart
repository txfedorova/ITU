import 'dart:convert'; // For JSON

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle

class SwipeImageGallery extends StatefulWidget {
  // final List<String> imageUrls = [
  //   'https://www.pravilamag.ru/upload/img_cache/8b5/8b5b05621633ac88c90f620d10e236fd_ce_2369x1477x0x54_fitted_1332x0.jpg',
  //   'https://cdn.xsd.cz/original/3be921bb895f36519fff1cae159fcb85.jpg',
  // ];
  
  //final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
// This returns a List<String> with all your images
  //final imageAssetsList = assetManifest.listAssets().where((string) => string.startsWith("assets/images/")).toList()

  @override
  _SwipeImageGalleryState createState() => _SwipeImageGalleryState();


}

class _SwipeImageGalleryState extends State<SwipeImageGallery> {
  //late List<String> imageNames; // = ['Forrest_Gump.jpg', 'Kolija.jpg'];
  List<String> imageNames = ['Forrest_Gump.jpg', 'Kolija.jpg'];
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    //_initImages(); // The image list is empty after calling this method
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
            // child: Image.network(
            //   widget.imageUrls[index],
            //   fit: BoxFit.cover,
            // ),
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