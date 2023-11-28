import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final CardSwiperController _controller = CardSwiperController();
  List<String> imageNames = ['Forrest_Gump.jpg', 'Kolija.jpg'];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: CardSwiper(
          controller: _controller,
          cardsCount: imageNames.length,
          cardBuilder: (context, index, _, __) {
            return SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Image.asset('images/${imageNames[index]}', fit: BoxFit.cover),
            );
          },
          onSwipe: (previousIndex, currentIndex, direction) {
            debugPrint('Card swiped from $previousIndex to $currentIndex in direction ${direction.name}');
            return true;
          },
          numberOfCardsDisplayed: 2,
          backCardOffset: const Offset(-30, 0),
          //padding: EdgeInsets.only(bottom: screenSize.height * 0.05), // Отступ снизу, чтобы вторая карточка была видна
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
