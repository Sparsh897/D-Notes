// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notes_app/auth/signin_screen.dart';
import 'package:notes_app/notes/edit_note.dart';
import 'package:notes_app/notes/new_note.dart';
import 'package:notes_app/provider/note_provider.dart';
import 'package:notes_app/recycle/recycle1.dart';
import 'package:provider/provider.dart';

class Note3 extends StatefulWidget {
  const Note3({Key? key}) : super(key: key);

  @override
  State<Note3> createState() => _Note3State();
}

class _Note3State extends State<Note3> {
  Future<void> moveSelectedNotesToBin(NoteProvider noteProvider) async {
    await noteProvider.movemultipletobin(noteProvider.selectedNoteIds);
    await noteProvider.fetchRecycledNotes();
  }

  Future<void> showDialog1(
      BuildContext context, String docId, NoteProvider noteProvider) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text("Recycle Bin",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              Text(
                "Move this note to recycle bin,You can restore it anytime form the bin!!",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                noteProvider.moveToRecycleBin(docId);
                Navigator.pop(context);
              },
              child: const Text(
                "Move",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> setPassword1(
    BuildContext context,
    String docId,
    NoteProvider noteProvider,
  ) async {
    bool isPasswordSet = false;
    String enteredPassword = "";
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Password",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text(
                  "Add protection to your note",
                  style: TextStyle(fontSize: 15),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    enteredPassword = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    isPasswordSet = enteredPassword == value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isPasswordSet ) {
                  await noteProvider.setPassword(
                      context, docId, enteredPassword);
                       await noteProvider.fetchNotes();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password set successfully!"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Passwords do not match!"),
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialog2(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "LOGOUT",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Are You sure, you want to logout?",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (mounted) {
                  Provider.of<NoteProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                }
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showunlockDialogue(
      BuildContext context, String docId, NoteProvider noteProvider) async {
    TextEditingController unlockedpassword = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Unlock",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text(
                  "Unlock your note",
                  style: TextStyle(fontSize: 15),
                ),
                TextFormField(
                  controller: unlockedpassword,
                  decoration: const InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.password),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await noteProvider.unlockNote(
                    unlockedpassword.text.trim(), docId);
                await noteProvider.fetchNotes();
                Navigator.pop(context);
              },
              child: const Text(
                "Unlock",
                style: TextStyle(color: Color.fromARGB(255, 3, 88, 6)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool longPressed = Provider.of<NoteProvider>(context).noteisLongpressd;
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
        tabs: [
          GButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Recyclenote()));
            },
            icon: Icons.recycling,
            text: "Recycle Bin",
          ),
          GButton(
            onPressed: () {
              showDialog2(context);
            },
            icon: Icons.logout_outlined,
            text: "Logout",
          )
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Notes"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<NoteProvider>(
              builder: (context, notesProvider, child) {
                if (notesProvider.notes.isEmpty) {
                  notesProvider.fetchNotes();
                }
                if (notesProvider.notes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: notesProvider.notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: (notesProvider.notes[index].isPassword != null)
                              ? ListTile(
                                  onTap: () {
                                    showunlockDialogue(
                                        context,
                                        notesProvider.notes[index].id!,
                                        notesProvider);
                                  },
                                  leading: const Icon(Icons.lock_rounded),
                                  title: Text(
                                    notesProvider.notes[index].title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  subtitle: null,
                                )
                              : Slidable(
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        icon: Icons.edit_document,
                                        backgroundColor: Colors.grey.shade600,
                                        onPressed: (context) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EditNote(
                                                docId: notesProvider
                                                    .notes[index].id!,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const BehindMotion(),
                                    children: [
                                      SlidableAction(
                                        icon: Icons.lock,
                                        backgroundColor: Colors.grey,
                                        onPressed: (context) {
                                          setPassword1(
                                              context,
                                              notesProvider.notes[index].id!,
                                              notesProvider);
                                        },
                                      ),
                                      SlidableAction(
                                        icon: Icons.delete_forever,
                                        backgroundColor: Colors.red.shade400,
                                        onPressed: (context) {
                                          showDialog1(
                                              context,
                                              notesProvider.notes[index].id!,
                                              notesProvider);
                                        },
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    onLongPress: () {
                                      notesProvider.noteisLongpressed();
                                    },
                                    trailing: (longPressed)
                                        ? Checkbox(
                                            onChanged: (bool? value) {
                                              if (value != null) {
                                                notesProvider
                                                    .toggleNoteSelection(
                                                        notesProvider
                                                            .notes[index].id!);
                                              }
                                            },
                                            value: notesProvider.selectedNoteIds
                                                .contains(notesProvider
                                                    .notes[index].id),
                                          )
                                        : const Text("date"),
                                    leading: CircleAvatar(
                                      child: Text(notesProvider
                                          .notes[index].title!
                                          .substring(0, 1)),
                                    ),
                                    title: Text(
                                      notesProvider.notes[index].title!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      notesProvider.notes[index].description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              (Provider.of<NoteProvider>(context).selectedNoteIds.isNotEmpty)
                  ? ElevatedButton(
                      onPressed: () async {
                        final notesProvider =
                            Provider.of<NoteProvider>(context, listen: false);
                        await moveSelectedNotesToBin(notesProvider);
                        if(mounted){
                          Provider.of<NoteProvider>(context, listen: false)
                            .notecancelClicked();
                        }
                      },
                      child: Text(
                          "toBin(${Provider.of<NoteProvider>(context).selectedNoteIds.length})"))
                  : Container(),
              (longPressed)
                  ? ElevatedButton(
                      onPressed: () {
                        Provider.of<NoteProvider>(context, listen: false)
                            .notecancelClicked();
                      },
                      child: const Text("Cancel"))
                  : Container()
            ],
          )
        ],
      ),
      floatingActionButton: (longPressed)
          ? Container()
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const NewNote()),
                );
              }),
    );
  }
}
