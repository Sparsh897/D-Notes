import 'package:flutter/material.dart';
import 'package:notes_app/provider/note_provider.dart';
import 'package:provider/provider.dart';


class EditNote extends StatefulWidget {
  final String docId;
  const EditNote({Key? key, required this.docId}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<void> updateNote() async {
    if (_formKey.currentState!.validate()) {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
      await noteProvider.updateNote(
        noteId: widget.docId,
        title: titleController.text.trim(),
        description: descController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }


  Future<void> fetchNoteData(BuildContext context) async {
      final noteProvider = Provider.of<NoteProvider>(context, listen: false);
  await  Provider.of<NoteProvider>(context, listen: false)
        .fetchNoteData(widget.docId);
        titleController.text = noteProvider.fetchedTitle;
    descController.text = noteProvider.fetchedDescription;
  }

  @override
  void initState() {
    super.initState();
    fetchNoteData(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  final valid = _formKey.currentState!.validate();
                  if (!valid) {
                    return;
                  }
                  _formKey.currentState!.save();
                  await updateNote();
                } catch (e) {
                
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(e.toString()),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
          automaticallyImplyLeading: false,
          title: const Text("Edit Note"),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 140,
                  style: const TextStyle(fontSize: 18),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(10, 10))),
                    labelText: 'Edit Title',
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: TextFormField(
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: null,
                    style: const TextStyle(fontSize: 18),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Cannot be empty";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(10, 10))),
                      labelText: 'Enter description',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      onPressed: () {
                        updateNote();
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
