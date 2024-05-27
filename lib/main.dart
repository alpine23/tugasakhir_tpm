import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'services/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sessionService = SessionService();
  final username = await sessionService.getSession();
  runApp(MyApp(initialRoute: username == null ? '/login' : '/home'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          headline6: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontFamily: 'Montserrat'),
          button: TextStyle(fontFamily: 'Montserrat'),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
