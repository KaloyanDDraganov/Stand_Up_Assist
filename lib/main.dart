import 'package:flutter/cupertino.dart';

import 'widgets/HomePage.dart';

void main() {
  runApp(const StandUpAssist());
}

class StandUpAssist extends StatefulWidget {
  const StandUpAssist({Key? key}) : super(key: key);

  @override
  State<StandUpAssist> createState() => _StandUpAssistState();
}

class _StandUpAssistState extends State<StandUpAssist>
    with WidgetsBindingObserver {
  Brightness? _brightness;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _brightness = WidgetsBinding.instance?.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance?.window.platformBrightness;
      });
    }

    super.didChangePlatformBrightness();
  }

  CupertinoThemeData get _lightTheme => const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.black,
      );

  CupertinoThemeData get _darkTheme => const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.white,
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Stand Up Assist',
      theme: _brightness == Brightness.dark ? _darkTheme : _lightTheme,
      home: const HomePage(title: 'Stand Up Assist'),
    );
  }
}
