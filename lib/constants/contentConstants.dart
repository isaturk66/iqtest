import 'package:flutter/material.dart';
import 'package:iqtest/models/testModels.dart';

final List<Collection> collections = [
  Collection(
      title: "IQ Test",
      desc: "Multiple IQ testing options that measure IQ in the following way",
      image: Image.asset("asset/img/testTileBanner.png"),
      tests: [IQTEST])
];

final IQTEST = Test(
  title: "General IQ", 
  id: "general_iq",
  themeColor: const Color(0xFF71c2ff),
  resultBanner: Image.asset("assets/img/iqTestResultBanner.png"),
  questions: [
  const SimpleQuestion(
      title: "This depression quiz is based on the Depression Screening",
      options: [
        TextOption(
          text: "111",
        ),
        TextOption(
          text: "222",
        ),
        TextOption(
          text: "333",
        ),
        TextOption(
          text: "444",
        ),
        TextOption(
          text: "555",
        ),
      ]),
  const SimpleQuestion(
      title: "This depression quiz is based on the other shit Screening",
      options: [
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
      ]),
  const SimpleQuestion(
      title: "This depression quiz is based on the other other shit Screening",
      options: [
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
        TextOption(
          text: "265",
        ),
      ]),
  ImageQuestion(
      title: "This depression quiz is based on the image Screening",
      image: Image.asset("assets/img/dummy1.png"),
      options: [
        const TextOption(
          text: "265",
        ),
        const TextOption(
          text: "265",
        ),
        const TextOption(
          text: "265",
        ),
        const TextOption(
          text: "265",
        ),
        const TextOption(
          text: "265",
        ),
      ]),
  VerticalQuestion(
      image: Image.asset("assets/img/verticalDummy.png"),
      text: "I am meticulous and organized",
      title:
          "Please give your possible rating to assess your scores in result section")
]);
