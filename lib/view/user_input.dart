import 'package:flutter/material.dart';

class UserInputWidget extends StatefulWidget {
  @override
  _UserInputWidgetState createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> users = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: users.asMap().entries.map((entry) {
            final int index = entry.key;
            final String user = entry.value;
            return Container(
              height: 55,
              child: Card(
                margin: const EdgeInsets.all(3.0), // Add margin for spacing
                child: ListTile(
                  title: Text(user),
                  trailing: IconButton(
                    icon: Icon(Icons.close), // X icon for delete
                    onPressed: () {
                      // Remove the user from the list
                      setState(() {
                        users.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'User Name', // Display the hint text
              hintStyle:
                  TextStyle(color: Colors.grey), // Style for the hint text
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.black), // Border color when focused
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
       
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Adjust the radius as needed
            ),
            padding: const EdgeInsets.all(14),
            // backgroundColor: const Color(0xFF59B773),
            // foregroundColor: Colors.white,
          ),
          onPressed: () {
            final userName = _nameController.text;
            if (userName.isNotEmpty) {
              setState(() {
                users.add(userName);
              });
              // Add user to your data source or perform the necessary action
              // You can use context.read<UserController>().addUser(userName);
              _nameController.clear(); // Clear the input field
            }
          },
          child: const Text(
            'Add a new user',
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }
}
