// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';

import 'package:notes_app/notes/notes_page.dart';
import 'package:notes_app/provider/note_provider.dart';

import 'package:provider/provider.dart';


class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Future<void> _addNote() async {
  //   final valid = _formKey.currentState!.validate();
  //   if (!valid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   String? accessToken = await MySharedPreferences.getAccessToken();
  //   if (accessToken == null) {
  //     throw Exception('Access token not found');
  //   }
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://10.0.2.2:5003/api/note/createnote'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'title': titleController.text.trim(),
  //         'description': descriptionController.text.trim(),
  //       }),
  //     );
  //     if (response.statusCode == 201) {
  //       print(response);
  //     } else {
  //       throw Exception('Failed to add note');
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> _addNote() async {
  //   final valid = _formKey.currentState!.validate();
  //   if (!valid) {
  //     return;
  //   }
  //   _formKey.currentState!.save();

  // }

  void addNewNote() {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    noteProvider.createNote(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
    );
    // Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final valid = _formKey.currentState!.validate();
                  if (!valid) {
                    return;
                  }
                  _formKey.currentState!.save();
                  addNewNote();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => Note3()));
                },
                icon: Icon(Icons.add))
          ],
          automaticallyImplyLeading: false,
          title: Text(
            "Add a new Note",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    controller: titleController,
                    maxLength: 140,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(10, 10))),
                      label: Text(
                        'Title',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Cannot be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: descriptionController,
                      maxLength: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(10, 10))),
                        label: Text(
                          'Enter description',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final valid = _formKey.currentState!.validate();
                          if (!valid) {
                            return;
                          }
                          _formKey.currentState!.save();
                          // _addNote();
                          addNewNote();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (_) => Note3()));
                        },
                        child: Text("Add Task")),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
