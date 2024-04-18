// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:notes_app/auth/signin_screen.dart';
import 'package:notes_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class Forgotpass extends StatefulWidget {
  const Forgotpass({Key? key}) : super(key: key);

  @override
  State<Forgotpass> createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword(String email, UserProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      authProvider.forgotpassLoading();
      try {
        await Future.delayed(Duration(seconds: 3));
        final resposne = await Provider.of<UserProvider>(context, listen: false)
            .resetPassword(email);
        if (resposne) {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password reset link send to the Email",
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          _emailController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User not Found'),
            ),
          );
          _emailController.clear();
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.toString(),
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } finally {
        authProvider.stopforgotpassLoading();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => SignInScreen()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromARGB(255, 244, 241, 251),
        title: const Text('Forgot Password'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email and we\'ll send you a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains("@")) {
                    return 'Please enter a valid Email';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Consumer<UserProvider>(builder: (context, authProvider, child) {
                return ElevatedButton(
                  onPressed: () {
                    resetPassword(_emailController.text, authProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: authProvider.resetLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text("Reset Password"),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
