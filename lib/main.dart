import 'package:flutter/material.dart';
import 'package:flutter_vscode/expense_tracker.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(const MyApp());
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).size.height);
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true, // Enable Material 3
      ).copyWith(
        scaffoldBackgroundColor: Colors.blue.shade100,
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true, // Enable Material 3 for dark theme
      ).copyWith(
        scaffoldBackgroundColor: Colors.blueGrey.shade800,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: ExpenseTracker(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}
