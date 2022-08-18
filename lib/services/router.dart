import 'package:flutter/material.dart';
import 'package:iqtest/pages/skeleton.dart';

var onGenerateRoute = (settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const Skeleton());
    default:
  }
};
