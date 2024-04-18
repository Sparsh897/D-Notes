// import 'dart:convert';

// import 'package:notes_app/trash/notemodel.dart';
// import "package:http/http.dart" as http;
// import 'package:notes_app/models/shared_prefrence.dart';

// class ApiServices {
//   static String _baseUrl = "http://10.0.2.2:5003/api/note";


//  static  void addNote(Note note) async {
//     String? accessToken = await MySharedPreferences.getAccessToken();
//     Uri requestUri = Uri.parse(_baseUrl + "createnote");
//     var response = await http.post(
//       requestUri,
//       body: note.toMap(),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//     var decoded = jsonDecode(response.body);
//     print(decoded.toString());
//   } 
//   static  void getNotes(Note note) async {
//     String? accessToken = await MySharedPreferences.getAccessToken();
//     Uri requestUri = Uri.parse(_baseUrl + "createnote");
//     var response = await http.post(
//       requestUri,
//       body: note.toMap(),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $accessToken',
//       },
//     );
//     var decoded = jsonDecode(response.body);
//     print(decoded.toString());
//   }
// }
