import 'package:flutter/cupertino.dart';

import 'states/HomePageState.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}
