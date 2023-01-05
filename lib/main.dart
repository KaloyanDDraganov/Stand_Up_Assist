import 'package:flutter/cupertino.dart';

import 'widgets/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Stand Up Assist',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.white,
        brightness: Brightness.dark,
      ),
      home: HomePage(title: 'Stand Up Assist'),
    );
  }
}
