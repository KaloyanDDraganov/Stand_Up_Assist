import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'widgets/HomePage.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>
    with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Analyzer',
      home: const HomePage(title: 'Sleep Analyzer'),
    );
  }
}
