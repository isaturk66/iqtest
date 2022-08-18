import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iqtest/states/UIState.dart';
import 'package:provider/provider.dart';
import './services/router.dart' as router;

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UIState()),
      ],
      child: ScrollConfiguration(
        behavior: NoGlowBehaviour(),
        child: const App(),
      )));
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.onGenerateRoute,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
