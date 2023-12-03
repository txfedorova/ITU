import 'package:flutter/material.dart';
import '../controller/user_controller.dart';

class UserInputWidget extends StatefulWidget {
  // final VoidCallback onUserAdded;
  final void Function(int userId) onUserSelected;

  const UserInputWidget({
    Key? key,
    // required this.onUserAdded,
    required this.onUserSelected,
  }) : super(key: key);

  @override
  State<UserInputWidget> createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
  final TextEditingController _nameController = TextEditingController();
  final UserController _userController = UserController();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    var allUsers = await _userController.getUsers();
    setState(() {
      users = allUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: users.map((user) {
            return SizedBox(
              height: 55,
              child: Card(
                margin: const EdgeInsets.all(3.0),
                child: ListTile(
                  title: Text(user['name']),
                  onTap: () {
                    // Callback function when a user is selected
                    widget.onUserSelected(user['id']);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      await _userController.removeUser(user['id']);
                      _loadUsers();
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
              hintText: 'User Name',
              hintStyle: TextStyle(color: Colors.grey),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(14),
          ),
          onPressed: () async {
            final userName = _nameController.text;
            if (userName.isNotEmpty) {
              await _userController.addUser(userName);
              _nameController.clear();
              _loadUsers();

              // widget.onUserAdded();
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
