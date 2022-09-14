import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqtest/algorithms/uihelpers.dart';
import 'package:iqtest/constants/routeConstants.dart';

import 'package:iqtest/models/testModels.dart';
import 'package:iqtest/services/router.dart';
import 'package:iqtest/services/service_locator.dart';
import 'package:iqtest/states/testState.dart';
import 'package:provider/provider.dart';

class OptionsState extends ChangeNotifier {
  var selectedOption;
}

class OptionWidget extends StatefulWidget {
  final option;
  final int index;

  OptionWidget({super.key, required this.option, required this.index});

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> {
  Widget RadioButton(BuildContext context) {
    OptionsState state = context.watch<OptionsState>();
    return GestureDetector(
      onTap: () {
        setState(() {
          state.selectedOption = widget.index;
          state.notifyListeners();
        });
      },
      child: Container(
          width: designW(18, context),
          height: designW(18, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(designW(9, context)),
            border: Border.all(
              color: Color(0xFF7BA7E8),
              width: designW(2, context),
            ),
          ),
          child: Center(
            child: Container(
                width: designW(11, context),
                height: designW(11, context),
                decoration: BoxDecoration(
                  color: widget.index == state.selectedOption
                      ? Color(0xFF7BA7E8)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(designW(6, context)),
                )),
          )),
    );
  }

  Widget OptionBody(BuildContext context) {
    if (widget.option is ImageOption) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 50, height: 50, color: Colors.redAccent),
            RadioButton(context)
          ],
        ),
      );
    }
    if (widget.option is TextOption) {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            RadioButton(context),
            Expanded(
              flex: 4,
              child: Container(),
            ),
            Text(widget.option.text),
            Expanded(
              flex: 4,
              child: Container(),
            ),
          ],
        ),
      );
    }
    if (widget.option is VerticalOption) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.option.text),
            Container(
              width: designW(35, context),
            ),
            RadioButton(context),
          ],
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: designH(40, context),
        minWidth: designW(110, context),
        maxWidth: designW(140, context),
      ),
      child: OptionBody(context),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.test}) : super(key: key);

  final Test test;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  late Image? image;
  Completer<ui.Image> completer = Completer<ui.Image>();

  int currentQuestion = 0;
  List<Widget> currentOptionList = [];

  double bodyheight = 50;
  double imageHeaderHeight = 0;
  double imageHeaderGap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bookmarkedLocation();
    prepareContent();
  }

  void clue() {}

  void finishTest() {
    Navigator.of(context).pushNamed(resultRoute,
        arguments: TestResultsPageArguments(test: widget.test));
  }

  void bookmarkedLocation() {
    TestState testState = locator<TestState>();

    var savedAnswers = testState.userAnswers
        .firstWhere((element) => element.id == widget.test.id)
        .answers;
    for (var i = 0; i < savedAnswers.length; i++) {
      if (savedAnswers[i] == 99) {
        currentQuestion = i;
        return;
      }
    }
    currentQuestion = savedAnswers.length - 1;
  }

  void prepareContent() {
    // ignore: prefer_function_declarations_over_variables

    currentOptionList = List<Widget>.from(widget
        .test.questions[currentQuestion].options
        .asMap()
        .entries
        .map((entry) {
      int idx = entry.key;
      var val = entry.value;

      return OptionWidget(option: val, index: idx);
    }).toList());
    currentOptionList.shuffle();
    TestState testState = locator<TestState>();

    var savedOption = testState.userAnswers
        .firstWhere((element) => element.id == widget.test.id)
        .answers[currentQuestion];

    if (savedOption != 99) {
      context.read<OptionsState>().selectedOption = savedOption;
    }
  }

  void nextQuestion() {
    var selectedOption = context.read<OptionsState>().selectedOption;
    if (selectedOption != null) {
      if (currentQuestion != widget.test.questions.length - 1) {
        setState(() {
          processForm();
          resetFormState();
          currentQuestion++;
          prepareContent();
        });
      } else {
        finishTest();
        processForm();
      }
    }
  }

  void previousQuestion() {
    var selectedOption = context.read<OptionsState>().selectedOption;
    if (currentQuestion != 0) {
      setState(() {
        if (selectedOption != null) {
          processForm();
        }
        resetFormState();
        currentQuestion--;
        prepareContent();
      });
    }
  }

  void processForm() {
    var selectedOption = context.read<OptionsState>().selectedOption;
    TestState testState = locator<TestState>();
    testState.userAnswers
        .firstWhere((element) => element.id == widget.test.id)
        .updateQuestion(currentQuestion, selectedOption);
  }

  void resetFormState() {
    completer = Completer<ui.Image>();
    image = null;
    context.read<OptionsState>().selectedOption = null;
  }

  Widget simpleBody() {
    // ignore: prefer_function_declarations_over_variables

    return Container(
        child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceAround,
            spacing: designW(20, context),
            children: currentOptionList));
  }

  Widget verticalBody() {
    // ignore: prefer_function_declarations_over_variables
    return Container(
      child: Column(
        children: [
          Container(
            //alignment: Alignment.center,
            width: designW(310, context),
            height: designW(310, context) / 4.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(designW(10, context)),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3, 3),
                      blurRadius: 12)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.test.questions[currentQuestion].text,
                style: GoogleFonts.inter(fontSize: designW(14, context)),
              ),
            ),
          ),
          Expanded(
              child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: designW(25, context),
                  right: designW(25, context),
                  top: designH(10, context),
                  bottom: designH(10, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    child: widget.test.questions[currentQuestion].image,
                  ),
                  Column(
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: currentOptionList)
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget questionBody(Question question) {
    if (question is SimpleQuestion || question is ImageQuestion) {
      return simpleBody();
    }

    if (question is VerticalQuestion) {
      return verticalBody();
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.test.questions[currentQuestion] is ImageQuestion) {
      image = widget.test.questions[currentQuestion].image;

      image!.image
          .resolve(new ImageConfiguration())
          .addListener(ImageStreamListener((ImageInfo info, bool _) {
        Future.delayed(Duration(milliseconds: 200), () {
          if (!completer.isCompleted) {
            completer.complete(info.image);
          }
        });

        var headHeight;

        if ((designW(335, context) / info.image.width) * info.image.height >
            designH(180, context)) {
          headHeight = designH(180, context);
        } else {
          headHeight =
              (designW(335, context) / info.image.width) * info.image.height;
        }

        setState(() {
          imageHeaderHeight = headHeight;
          imageHeaderGap = designH(15, context);
        });
      }));
    } else {
      if (imageHeaderHeight != 0 || imageHeaderGap != 0) {
        setState(() {
          imageHeaderHeight = 0;
          imageHeaderGap = 0;
        });
      }
    }

    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                height: designH(190, context),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top +
                          designH(20, context),
                    ),
                    Row(
                      children: [
                        Container(
                          width: designW(20, context),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.arrow_back)),
                        Container(
                          width: designW(15, context),
                        ),
                        Text(
                          widget.test.title,
                          style: GoogleFonts.oxygen(
                            fontSize: designW(16, context),
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: designH(15, context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: designW(15, context)),
                      child: Text(
                        "${currentQuestion + 1}. ${widget.test.questions[currentQuestion].title}",
                        style: GoogleFonts.inter(
                            fontSize: designW(14, context),
                            color: Color(0xFF848588)),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                color: const Color(0xFF1A66D8).withOpacity(0.10),
              ))
            ],
          ),
          Positioned(
              //top: designH(140, context),
              bottom: designH(110, context),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 20)
                    ]),
                height: MediaQuery.of(context).size.height -
                    (designH(260, context) +
                        imageHeaderHeight +
                        imageHeaderGap),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: designH(20, context),
                    ),
                    Expanded(
                      child: Container(
                        width: designW(335, context),
                        constraints: BoxConstraints(
                          minHeight: designH(270, context),
                        ),
                        //color: Colors.redAccent,
                        child: Column(
                          children: [
                            Expanded(
                                child: questionBody(
                                    widget.test.questions[currentQuestion])),
                            Container(height: designH(10, context)),
                            Stack(
                              children: [
                                Container(
                                  width: designW(295, context),
                                  height: designW(295, context) / 27,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(
                                          designW(295, context) / 54)),
                                ),
                                Container(
                                  width: designW(295, context) *
                                      (!(widget.test.questions.length == 1 ||
                                              widget.test.questions.length == 0)
                                          ? (currentQuestion /
                                              (widget.test.questions.length -
                                                  1))
                                          : currentQuestion / 1),
                                  height: designW(295, context) / 27,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF7BA7E8),
                                      borderRadius: BorderRadius.circular(
                                          designW(295, context) / 54)),
                                ),
                              ],
                            ),
                            Container(height: designH(5, context)),
                            Text(
                                "${currentQuestion + 1}/${widget.test.questions.length}"),
                            Container(height: designH(5, context)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: previousQuestion,
                                  child: Container(
                                    width: designW(100, context),
                                    height: designW(100, context) / 3,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF848588)),
                                        borderRadius: BorderRadius.circular(
                                            designW(100, context) / 6)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: designW(7, context),
                                        right: designW(7, context),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Back",
                                              style: GoogleFonts.inter(
                                                  fontSize:
                                                      designW(14, context))),
                                          const Icon(Icons.arrow_back,
                                              color: Color(0xFF848588))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: clue,
                                  child: Container(
                                    width: designW(45, context),
                                    height: designW(45, context) * (2 / 3),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF848588)),
                                        borderRadius: BorderRadius.circular(
                                            designW(100, context) / 6)),
                                    child: const Center(
                                      child: Icon(Icons.search,
                                          color: Color(0xFF848588)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: nextQuestion,
                                  child: Container(
                                    width: designW(100, context),
                                    height: designW(100, context) / 3,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF848588)),
                                        borderRadius: BorderRadius.circular(
                                            designW(100, context) / 6)),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: designW(7, context),
                                        right: designW(7, context),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("Next",
                                              style: GoogleFonts.inter(
                                                  fontSize:
                                                      designW(14, context))),
                                          const Icon(Icons.arrow_forward,
                                              color: Color(0xFF848588))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(height: designH(5, context)),
                            Text("See Answer",
                                style: GoogleFonts.inter(
                                    fontSize: designW(11, context),
                                    color: const Color(0xFF848588))),
                            Container(height: designH(10, context)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Positioned(
              top: designH(150, context),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: imageHeaderHeight,
                width: designW(335, context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 20)
                    ]),
                constraints: BoxConstraints(maxHeight: designH(180, context)),
                child: FutureBuilder<ui.Image>(
                  future: completer.future,
                  builder:
                      (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(designW(10, context)),
                          child: image,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )),
        ],
      ),
    ));
  }
}
