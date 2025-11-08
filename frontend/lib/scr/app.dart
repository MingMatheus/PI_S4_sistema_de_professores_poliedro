import 'package:flutter/material.dart';
import 'telas/login/login_screen.dart';   
import 'theme/app_theme.dart';       
import 'telas/home/professor_home_screen.dart'; // import da tela nova

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

      home: LoginScreen(),

      routes: {
        '/professor-home': (context) => const ProfessorHomeScreen(),
      },
    );
  }
}
