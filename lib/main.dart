import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Swipe Image Viewer'),
        ),
        body: SwipeImageGallery(),
      ),
    );
  }
}

class SwipeImageGallery extends StatefulWidget {
  final List<String> imageUrls = [
    'https://www.pravilamag.ru/upload/img_cache/8b5/8b5b05621633ac88c90f620d10e236fd_ce_2369x1477x0x54_fitted_1332x0.jpg',
    'https://cdn.xsd.cz/original/3be921bb895f36519fff1cae159fcb85.jpg',
  ];

  @override
  _SwipeImageGalleryState createState() => _SwipeImageGalleryState();
}
class _SwipeImageGalleryState extends State<SwipeImageGallery> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: widget.imageUrls.length,
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
                height: Curves.easeInOut.transform(value) * MediaQuery.of(context).size.height,
                width: Curves.easeInOut.transform(value) * MediaQuery.of(context).size.width,
                child: child,
              ),
            );
          },
          child: Image.network(
            widget.imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}

