
import 'package:flutter/material.dart';

import 'package:notes_app/auth/signin_screen.dart';
import 'package:notes_app/models/shared_prefrence.dart';
import 'package:notes_app/notes/notes_page.dart';
import 'package:notes_app/provider/auth_provider.dart';

import 'package:provider/provider.dart';

import 'provider/note_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String? accessToken = MySharedPreferences.getAccessToken();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: accessToken != null ? const Note3() : const SignInScreen()),
    );
  }
}
