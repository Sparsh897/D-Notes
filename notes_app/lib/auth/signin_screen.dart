// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_local_variable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/auth/forgotpage.dart';
import 'package:notes_app/notes/notes_page.dart';
import 'package:notes_app/auth/signup_screen.dart';
import 'package:notes_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';



class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showPass = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formSignInKey = GlobalKey<FormState>();

  Future<void> siginwemail(
      String email, String password, UserProvider authprovider) async {
    if (_formSignInKey.currentState!.validate()) {
      authprovider.signinIsLoading();
     
      try {
        await Future.delayed(Duration(seconds: 3));
      final loginresult= await authprovider.siginwemail(email, password);
      if(loginresult){
Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (_) => Note3()), (route) => false);
      }
         else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
        
        ),
      );
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
                    "error",
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } finally {
        authprovider.stopLoading();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome back',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains("@")) {
                              return 'Please enter a valid Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          autofocus: false,
                          controller: passwordController,
                          obscureText: showPass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: (showPass)
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showPass = false;
                                      });
                                    },
                                    icon: Icon(Icons.visibility))
                                : IconButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      setState(() {
                                        showPass = true;
                                      });
                                    },
                                    icon: Icon(Icons.visibility_off)),
                            label: const Text('Password'),
                            hintText: 'Enter Password',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Forgotpass()));
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                            width: 170,
                            child: Consumer<UserProvider>(
                              builder: (context, authProvider, child) {
                                return ElevatedButton(
                                  onPressed: (authProvider.isLoading)
                                      ? null
                                      : () async {
                                          await siginwemail(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                              authProvider);
                                        },
                                  child: authProvider.isLoading
                                      ? SizedBox(
                                          height: 27,
                                          width: 27,
                                          child: CircularProgressIndicator())
                                      : Text('Login'),
                                );
                              },
                            )),
                        const SizedBox(
                          height: 45.0,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Text(
                                'Continue with',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(thickness: 1, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35.0,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SignUpScreen()),
                                    (route) => false);
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
