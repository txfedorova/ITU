import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:itu_app/model/comment_model.dart';
import 'package:itu_app/controller/comment_controller.dart';

class CommentsScreen extends StatefulWidget {
  final int filmIndex;

  const CommentsScreen({required this.filmIndex, Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  //final CommentController _commentController = CommentController();
  final TextEditingController _commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var filmComments = context.watch<CommentController>().comments(widget.filmIndex);

    print("\n\nBUILDING LIST COMMENTS\n\n");
		// comments.then((comments) {
		// 	for (var comment in comments) {
		// 	  print(comment.text);
		// 	}
		// });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: filmComments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Comment> comments = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index].text),
                        subtitle: Text(comments[index].timestamp),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentTextController,
                    decoration: const InputDecoration(hintText: 'Add a comment'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    var commentController = context.read<CommentController>();
                    // Add the new comment
                    commentController.insertComment(
                      Comment(
                        filmId: widget.filmIndex,
                        text: _commentTextController.text,
                        timestamp: DateTime.now().toString(),
                      ),
                    );
                    // Clear the text field after adding the comment
                    _commentTextController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    //_commentController.dispose();
    _commentTextController.dispose();
    super.dispose();
  }
}
