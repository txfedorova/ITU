import 'package:flutter/material.dart';

import 'package:itu_app/model/film_model.dart';
import 'package:itu_app/controller/film_controller.dart';
import 'package:itu_app/common/utils.dart';

import 'package:provider/provider.dart';


class FilmEditScreen extends StatefulWidget {
  final Film? film;

  const FilmEditScreen({super.key, this.film});

  @override
  State<FilmEditScreen> createState() => _FilmEditScreenState();
}

class _FilmEditScreenState extends State<FilmEditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController directorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController actorsController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.film != null) {
      // Initialize controllers with the current film details
      titleController.text = widget.film!.title;
      yearController.text = widget.film!.year.toString();
      durationController.text = widget.film!.duration.toString();
      directorController.text = widget.film!.director;
      descriptionController.text = widget.film!.description;
      actorsController.text = widget.film!.actors;
      imageController.text = widget.film!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Film Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              TextFormField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Duration', errorText: 'Please enter the time in the format: hours:minutes:seconds'),
              ),
              TextFormField(
                controller: directorController,
                decoration: const InputDecoration(labelText: 'Director'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: actorsController,
                decoration: const InputDecoration(labelText: 'Actors'),
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save the edited film details here
                  final editedFilm = Film(
                    title: titleController.text,
                    year: int.parse(yearController.text),
                    director: directorController.text,
                    description: descriptionController.text,
                    actors: actorsController.text,
                    image: imageController.text,
                  );
                  if (durationController.text.isNotEmpty) {
                    editedFilm.duration = timeStringToDuration(durationController.text);
                  }
                  
                  // You can update the film details in your data source or database here
                  // Then navigate back to the previous screen or perform any other actions
                  context.read<FilmController>().insertFilm(editedFilm);

                  Navigator.of(context).pop();
                },
                child: Text(widget.film != null ? 'Save Changes' : 'Add Film'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}