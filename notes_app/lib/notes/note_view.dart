import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/notes/edit_note.dart';

class NoteView extends StatelessWidget {
  const NoteView({
    Key? key,
    required this.desc,
    required this.docId,
    required this.time,
    required this.title,
  }) : super(key: key);

  final String title;
  final String docId;
  final DateTime time;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EditNote(docId: docId,),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
        title: const Text(
          "NoteView",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  desc,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().add_jm().format(time),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text("OK"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
