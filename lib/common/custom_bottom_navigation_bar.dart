import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final void Function(int) onIndexChanged;

  const CustomBottomNavigationBar({Key? key, required this.onIndexChanged}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
        widget.onIndexChanged(index);
        print('Current index is $currentIndex');
      },
    );
  }
}