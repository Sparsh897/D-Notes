import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/models/notemodel1.dart';
import 'dart:convert';
import 'package:notes_app/models/shared_prefrence.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  List<Note> _recycledNotes = [];

  List<Note> get recycledNotes => _recycledNotes;

  final Set<String> _selectedNoteIds = {};

  Set<String> get selectedNoteIds => _selectedNoteIds;

  final Set<String> _RecycledselectedNoteIds = {};

  Set<String> get recycledselectedNoteIds => _RecycledselectedNoteIds;

  bool _noteisLongpressed = false;

  bool get noteisLongpressd => _noteisLongpressed;

  bool _recycledisLongpressed = false;

  bool get recycledisLongpressd => _recycledisLongpressed;

  String _fetchedTitle = '';
  String _fetchedDescription = '';

  String get fetchedTitle => _fetchedTitle;
  String get fetchedDescription => _fetchedDescription;

  final bool _isconnecting = false;
  bool get isconnecting => _isconnecting;

  bool _selectAll = false;

  bool get selectAll => _selectAll;

  Future<void> fetchNotes() async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final response = await http.get(
      Uri.parse('http://10.0.2.2:5003/api/note/getAllnotes'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );
    final responseData = json.decode(response.body) as List<dynamic>;
    _notes = responseData.map((noteData) => Note.fromJson(noteData)).toList();
    notifyListeners();
  }

  Future<void> createNote({
    required String title,
    required String description,
  }) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5003/api/note/createnote'),
        body: json.encode({
          'title': title,
          'description': description,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final newNote = Note.fromJson(responseData);
        _notes.add(newNote);
        notifyListeners();
      } else {
        print('Error creating note: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating note: $e');
    }
  }

  Future<void> moveToRecycleBin(String noteId) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final url = Uri.parse('http://10.0.2.2:5003/api/note/tobin/$noteId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print("Note moved to recycle bin");
      _notes.removeWhere((note) => note.id == noteId);
      notifyListeners();
    } else {
      throw Exception('Failed to move note to recycle bin');
    }
  }

  Future<void> setPassword(
    BuildContext context,
    String docId,
    String enteredPassword,
  ) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5003/api/note/password/$docId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'password': enteredPassword}),
      );
      if (response.statusCode == 200) {
        notifyListeners();
        print(response);
      } else {
        throw Exception('Failed to add password');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5003/api/note/updatenote/$noteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updatedNote = Note.fromJson(responseData);

        final index = _notes.indexWhere((note) => note.id == noteId);
        if (index != -1) {
          _notes[index] = updatedNote;
          notifyListeners();
        }
      } else {
        throw Exception('Error updating note: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating note: $e');
    }
  }

  Future<void> fetchRecycledNotes() async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5003/api/note/getrecyclednotes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responsedata = json.decode(response.body) as List<dynamic>;
        _recycledNotes =
            responsedata.map((data) => Note.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to fetch recycled notes');
      }
    } catch (e) {
      throw Exception('Failed to fetch recycled notes: $e');
    }
  }

  Future<void> unlockNote(String unlockedpassword, String docId) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5003/api/note/removepassword/$docId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'password': unlockedpassword}),
      );
      if (response.statusCode == 200) {
        print(response);
        notifyListeners();
      } else {
        throw Exception('Failed to add password');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> movemultipletobin(Set<String> selectedNoteIds) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5003/api/note/multipletobin'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'noteIds': selectedNoteIds.toList()}),
      );
      if (response.statusCode == 200) {
        _notes.removeWhere((note) => selectedNoteIds.contains(note.id));
        _selectedNoteIds.removeAll(selectedNoteIds);
        notifyListeners();
      } else {
        throw Exception('Failed to move notes to bin');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> restorefrombin(Set<String> selectedNoteIds) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:5003/api/note/restore'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'noteIds': selectedNoteIds.toList()}),
      );
      if (response.statusCode == 200) {
        final List<String> idsToRemove = List.from(recycledselectedNoteIds);
        _recycledNotes
            .removeWhere((note) => recycledselectedNoteIds.contains(note.id));
        _RecycledselectedNoteIds.removeAll(recycledselectedNoteIds);
        print(idsToRemove);
        notifyListeners();
      } else {
        throw Exception('Failed to move notes to bin');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePermanently(Set<String> selectedNoteIds) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5003/api/note/deletenotes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'noteIds': selectedNoteIds.toList()}),
      );
      if (response.statusCode == 200) {
        _recycledNotes
            .removeWhere((note) => recycledselectedNoteIds.contains(note.id));
        _RecycledselectedNoteIds.removeAll(recycledselectedNoteIds);
        notifyListeners();
      } else {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      print(e);
    }
  }

  void toggleRecycledNoteSelection(String noteId) {
    if (_RecycledselectedNoteIds.contains(noteId)) {
      _RecycledselectedNoteIds.remove(noteId);
    } else {
      _RecycledselectedNoteIds.add(noteId);
    }
    updateSelectAllStatus();
  }

  void toggleNoteSelection(String noteId) {
    for (var note in selectedNoteIds) {
      print(note);
    }
    if (_selectedNoteIds.contains(noteId)) {
      _selectedNoteIds.remove(noteId);
    } else {
      _selectedNoteIds.add(noteId);
    }
    notifyListeners();
  }

  void noteisLongpressed() {
    _noteisLongpressed = true;
    notifyListeners();
  }

  void recycledisLongpressed() {
    _recycledisLongpressed = true;
    notifyListeners();
  }

  void notecancelClicked() {
    _noteisLongpressed = false;
    final selectedNoteIdsCopy = Set<String>.from(_selectedNoteIds);
    _selectedNoteIds.removeAll(selectedNoteIdsCopy);
    notifyListeners();
  }

  void recyclecancelClicked() {
    _recycledisLongpressed = false;
    final recycledselectedNoteIdsCopy =
        Set<String>.from(_RecycledselectedNoteIds);
    _RecycledselectedNoteIds.removeAll(recycledselectedNoteIdsCopy);
    _selectAll = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      _notes.clear();
      _recycledNotes.clear();
      _selectedNoteIds.clear();
      _RecycledselectedNoteIds.clear();
      await MySharedPreferences.clearAccessToken();
      print('Logged out successfully');
      notifyListeners();
    } catch (e) {
      print('Error while logging out: $e');
    }
  }

  Future<void> fetchNoteData(String docId) async {
    String? accessToken = MySharedPreferences.getAccessToken();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5003/api/note/getNote/$docId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _fetchedTitle = data['title'];
        _fetchedDescription = data['description'];
        notifyListeners();
      } else {
        throw Exception('Failed to fetch note data');
      }
    } catch (e) {
      print("Error fetching note data: $e");
    }
  }

  void toggleSelectAll() {
    _selectAll = !_selectAll;
    if (_selectAll) {
      recycledselectedNoteIds.addAll(recycledNotes.map((note) => note.id!));
    } else {
      recycledselectedNoteIds.clear();
    }
    notifyListeners();
  }

  void updateSelectAllStatus() {
    if (_RecycledselectedNoteIds.length == _recycledNotes.length) {
      _selectAll = true;
    } else {
      _selectAll = false;
    }
    notifyListeners();
  }
}
