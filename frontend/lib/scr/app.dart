import 'package:flutter/material.dart';
import 'telas/login/login_screen.dart';   
import 'theme/app_theme.dart';       

class App extends StatefulWidget {
  @override
  State<App> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Poliedro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // tela de login
    );
  }
}