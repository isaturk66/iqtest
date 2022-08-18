import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:iqtest/constants/stateConstants.dart';

class UIState extends ChangeNotifier {
  String headerTitle = "Comprehensive Assesment Test";
  HeaderState headerState = HeaderState.homeState;
  Function backButtonCallback = () {};
}
