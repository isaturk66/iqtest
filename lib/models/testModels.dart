import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iqtest/constants/stateConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Collection {
  final String title, desc;
  final Image image;
  final List<Test> tests;

  const Collection(
      {required this.title,
      required this.desc,
      required this.image,
      required this.tests});
}

class Test {
  final String title;
  final String id;
  final List<dynamic> questions;
  final Color themeColor;
  final Image resultBanner;
  const Test({required this.themeColor, required this.resultBanner, required this.id, required this.title, required this.questions});
}

class UserAnswers {
  final String id;
  List<int> answers = [];

  UserAnswers(this.id);

  factory UserAnswers.withLenght(idd, length) {
    UserAnswers useranswer = UserAnswers(idd);
    useranswer.answers = List<int>.filled(length, 99);
    return useranswer;
  }

  UserAnswers.fromJson(Map<String, dynamic> json, String id)
      : id = json['id'],
        answers = jsonDecode(json['answers']).cast<int>();

  Map<String, dynamic> toJson() => {
        'id': id,
        'answers': jsonEncode(answers),
      };

  saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(id, jsonEncode(toJson()));
  }

  updateQuestion(questionIndex, value) {
    answers[questionIndex] = value;
    saveState();
  }
}

enum QuestionType { simple, photo, vertical }

class Question {
  final String title;
  final List<Option> options;

  const Question({required this.title, required this.options});
}

class SimpleQuestion extends Question {
  const SimpleQuestion({required super.title, required super.options});
}

class ImageQuestion extends Question {
  final Image image;

  const ImageQuestion(
      {required this.image, required super.title, required super.options});
}

class VerticalQuestion extends Question {
  final String text;
  final Image image;

  static const List<Option> optionss = [
    VerticalOption(text: "Very Often"),
    VerticalOption(text: "Often"),
    VerticalOption(text: "Sometimes"),
    VerticalOption(text: "Rarely"),
    VerticalOption(text: "Never"),
  ];

  VerticalQuestion(
      {required this.image,
      required this.text,
      required super.title,
      super.options = optionss});
}

class Option {
  const Option();
}

class TextOption extends Option {
  const TextOption({required this.text});

  final String text;
}

class VerticalOption extends Option {
  const VerticalOption({required this.text});

  final String text;
}

class ImageOption extends Option {
  final String asset;

  const ImageOption(this.asset);
}
