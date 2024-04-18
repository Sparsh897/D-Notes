import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notes_app/auth/signin_screen.dart';

import 'package:notes_app/provider/note_provider.dart';
import 'package:provider/provider.dart';

class Recyclenote extends StatefulWidget {
  const Recyclenote({super.key});

  @override
  State<Recyclenote> createState() => _RecyclenoteState();
}

class _RecyclenoteState extends State<Recyclenote> {
  Future<void> restoreSelectedNotes(NoteProvider recyclednoteProvider) async {
    await recyclednoteProvider
        .restorefrombin(recyclednoteProvider.recycledselectedNoteIds);
    recyclednoteProvider.fetchNotes();
  }

  // Future<void> deleteSelectedNotes(NoteProvider recyclednoteProvider) async {
  //   await recyclednoteProvider
  //       .deletePermanently(recyclednoteProvider.recycledselectedNoteIds);
  //   recyclednoteProvider.fetchNotes();
  // }

  Future<void> deleteNotes(
      BuildContext context, NoteProvider recyclednoteProvider) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Delete",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  "Are You sure, you want to permanently delete the selected notes?",
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
                  await recyclednoteProvider.deletePermanently(
                      recyclednoteProvider.recycledselectedNoteIds);
                  recyclednoteProvider.fetchNotes();
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Delete",
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

  @override
  Widget build(BuildContext context) {
    bool longPressed = Provider.of<NoteProvider>(context).recycledisLongpressd;
    bool selectAll = Provider.of<NoteProvider>(context).selectAll;
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
        tabs: [
          GButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.home,
            text: "Home",
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
        title: const Text("RecycledNotes"),
        actions: [
          (longPressed)
              ? Row(
                  children: [
                    const Text("SlectAll"),
                    Checkbox(
                      value: selectAll,
                      onChanged: (value) {
                        Provider.of<NoteProvider>(context, listen: false)
                            .toggleSelectAll();
                      },
                    ),
                  ],
                )
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<NoteProvider>(
              builder: (context, recycledNotesProvider, child) {
                if (recycledNotesProvider.recycledNotes.isEmpty) {
                  recycledNotesProvider.fetchRecycledNotes();
                }
                if (recycledNotesProvider.recycledNotes.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: recycledNotesProvider.recycledNotes.length,
                    itemBuilder: (context, index) {
                      final note = recycledNotesProvider.recycledNotes[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              child: ListTile(
                                onLongPress: () {
                                  recycledNotesProvider.recycledisLongpressed();
                                },
                                trailing: (longPressed)
                                    ? Checkbox(
                                        onChanged: (value) {
                                          if (value != null) {
                                            recycledNotesProvider
                                                .toggleRecycledNoteSelection(
                                                    recycledNotesProvider
                                                        .recycledNotes[index]
                                                        .id!);
                                          }
                                        },
                                        value: recycledNotesProvider
                                            .recycledselectedNoteIds
                                            .contains(recycledNotesProvider
                                                .recycledNotes[index].id),
                                      )
                                    : const Text("date"),
                                leading: CircleAvatar(
                                  child: Text(note.title!.substring(0, 1)),
                                ),
                                title: Text(
                                  note.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: Text(
                                  note.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
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
              (Provider.of<NoteProvider>(context)
                      .recycledselectedNoteIds
                      .isNotEmpty)
                  ? ElevatedButton(
                      onPressed: () async {
                        final recycledNotesProvider =
                            Provider.of<NoteProvider>(context, listen: false);
                        await restoreSelectedNotes(recycledNotesProvider);
                        if (mounted) {
                          Provider.of<NoteProvider>(context, listen: false)
                              .recyclecancelClicked();
                        }
                      },
                      child: Text(
                          "Restore(${Provider.of<NoteProvider>(context).recycledselectedNoteIds.length})"))
                  : Container(),
              (longPressed)
                  ? ElevatedButton(
                      onPressed: () {
                        Provider.of<NoteProvider>(context, listen: false)
                            .recyclecancelClicked();
                      },
                      child: const Text("Cancel"))
                  : Container(),
              (Provider.of<NoteProvider>(context)
                      .recycledselectedNoteIds
                      .isNotEmpty)
                  ? ElevatedButton(
                      onPressed: () async {
                        final recycledNotesProvider =
                            Provider.of<NoteProvider>(context, listen: false);
                        await deleteNotes(context, recycledNotesProvider);
                        if (mounted) {
                          Provider.of<NoteProvider>(context, listen: false)
                              .recyclecancelClicked();
                        }
                      },
                      child: Text(
                          "Delete(${Provider.of<NoteProvider>(context).recycledselectedNoteIds.length})"))
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
