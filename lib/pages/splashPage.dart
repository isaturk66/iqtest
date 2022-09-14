import 'dart:convert';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:iqtest/constants/contentConstants.dart';
import 'package:iqtest/constants/routeConstants.dart';
import 'package:iqtest/models/testModels.dart';
import 'package:iqtest/services/service_locator.dart';
import 'package:iqtest/states/testState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _getAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    TestState testState = locator<TestState>();

    collections.forEach((collection) {
      collection.tests.forEach((test) {
        var rawJson = prefs.getString(test.id);

        UserAnswers? userAnswers;
        if (rawJson != null) {
          try {
            userAnswers = UserAnswers.fromJson(jsonDecode(rawJson), test.id);
            print("created user anwer from json");
          } catch (e) {
            print(e);
            userAnswers =
                UserAnswers.withLenght(test.id, test.questions.length);
          }
        } else {
          userAnswers = UserAnswers.withLenght(test.id, test.questions.length);
        }
        testState.userAnswers.add(userAnswers);
      });
    });
  }

  initilalizeApp() async {
    await _getAnswers();
    Navigator.of(context).pushNamed(skeletonRoute);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initilalizeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
