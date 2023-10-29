import 'package:flutter/material.dart';

class ITUElevatedButton extends StatelessWidget {
  final Function onPressedCallback;
  final String buttonText;

  ITUElevatedButton({required this.onPressedCallback, required this.buttonText});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius as needed
          ),
          padding: const EdgeInsets.all(14),
          backgroundColor: const Color(0xFF59B773),
          foregroundColor: Colors.white,
        ),
        onPressed: onPressedCallback(),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18),
        ),
      );
  }
}