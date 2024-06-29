import 'package:flutter/material.dart';
import 'package:notes_app_flutter/auth/login.dart';
import 'package:notes_app_flutter/notes/get_notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  Future<bool> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    'https://images.unsplash.com/photo-1484246369503-9569d5dc9002?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        } else {
          if (snapshot.hasData && snapshot.data == true) {
            return const GetNotesScreen();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }
}
