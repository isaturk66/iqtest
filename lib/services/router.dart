import 'package:flutter/material.dart';
import 'package:iqtest/constants/routeConstants.dart';
import 'package:iqtest/models/testModels.dart';
import 'package:iqtest/pages/skeletonPage.dart';
import 'package:iqtest/pages/splashPage.dart';
import 'package:iqtest/pages/testPage.dart';
import 'package:iqtest/pages/testResultsPage.dart';
import 'package:provider/provider.dart';

class TestResultsPageArguments {
  final Test test;

  TestResultsPageArguments({required this.test});
}

var onGenerateRoute = (settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Splash());
    case skeletonRoute:
      return MaterialPageRoute(builder: (context) => const Skeleton());
    case resultRoute:
      return MaterialPageRoute(builder: (context) => TestResultsPage(settings.arguments));
    case testRoute:
      return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
              create: (_) => OptionsState(),
              child: TestPage(test: settings.arguments)));
    default:
  }
};
