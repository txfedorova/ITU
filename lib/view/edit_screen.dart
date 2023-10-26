
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:itu_app/model/film.dart';
//import 'package:itu_app/controller/film_controller.dart';
//import 'package:itu_app/model/user.dart';


class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  //final FilmController _filmController = FilmController();
  //final DogModel _dogModel = DogModel();

  final TextEditingController titleTextEditingController = TextEditingController();
  //final TextEditingController userEmailTextEditingController = TextEditingController();

  String rawText = '';
  //Film readUser = Film('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleTextEditingController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            // TextField(
            //   controller: userEmailTextEditingController,
            //   decoration: const InputDecoration(
            //     labelText: 'User email',
            //   ),
            // ),
            const SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: (){
            //     _filmController.writeToFile(Film(
            //       titleTextEditingController.text,
            //       userEmailTextEditingController.text
            //     ));
            //     setState(() {
            //       readUser = _filmController.readFromFile() as User;
            //     });
            //   },
            //   child: const Text('Save to JSON'),
            // ),
            // const SizedBox(height: 16.0),
            // Text('Name: ${readUser.name}\nEmail: ${readUser.email}'),
            // FutureBuilder<User>(
            //   future: _filmController.readFromFile(),
            //   builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Text('Loading...');
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       final user = snapshot.data;
            //       if (user != null) {
            //         return Text('Name: ${user.name}\nEmail: ${user.email}');
            //       } else {
            //         return const Text('User not found');
            //       }
            //     }
            //   },
            // ),
            const SizedBox(height: 16.0),
            // FutureBuilder<String>(
            //   future: _filmController.readFileRaw(),
            //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Text('Loading...');
            //     } else if (snapshot.hasError) {
            //       return Text('Error: ${snapshot.error}');
            //     } else {
            //       final jsonString = snapshot.data;
            //       if (jsonString != null) {
            //         return Text(jsonString);
            //       } else {
            //         return const Text('JSON not found');
            //       }
            //     }
            //   },
            // )
          ],
        ),
      ),
    );
  }
}