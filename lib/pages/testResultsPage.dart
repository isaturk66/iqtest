import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqtest/algorithms/uihelpers.dart';
import 'package:iqtest/constants/routeConstants.dart';
import 'package:iqtest/main.dart';
import 'package:iqtest/models/testModels.dart';
import 'package:iqtest/services/router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_switch/flutter_switch.dart';

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension LightTone on Color {
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

class MiniCard {
  final String testID, title;
  final Image image;

  MiniCard({required this.testID, required this.title, required this.image});
}

class TestResultsPage extends StatefulWidget {
  TestResultsPage(this.arguments, {Key? key}) : super(key: key);
  final TestResultsPageArguments arguments;

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  final PageController _controller = PageController();

  final TextStyle cardTitleStyle =
      GoogleFonts.oxygen(fontSize: 16, fontWeight: FontWeight.bold);

  final suggestedTests = [
    MiniCard(
        testID: "general_iq",
        title: "depression",
        image: Image.asset(
          "assets/img/depressionBanner.png",
          fit: BoxFit.fill,
        )),
  ];

  bool detailSwitchStatus = false;

  SvgPicture loadSVG() {
    final String rawSvg =
        """<?xml version="1.0"?><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="456.748" height="155.234" viewBox="0 0 456.748 155.234"><defs><linearGradient id="linear-gradient" x1="0.5" x2="0.5" y2="1" gradientUnits="objectBoundingBox"><stop offset="0" stop-color="${widget.arguments.test.themeColor.toHex()}"/><stop offset="0.397" stop-color="${widget.arguments.test.themeColor.lighten(0.16).toHex()}"/><stop offset="1" stop-color="#fff"/></linearGradient></defs><path id="Path_64" data-name="Path 64" d="M-16550-18962.262s27.064-79.045,47.375-79.045,13.135,51.9,32.838,52.379,17.277-21.9,35.824-21.9,19.059,44.285,34.629,44.285,21.493-72.855,32.24-72.379,20.885,50,35.227,50,25.523-39.164,50.152-38.57,13.435,42.855,25.077,50.475,20.9-21.426,31.644-20.475c7.361.652,6.567,10,19.105,12.855s25.945-36.324,34.032-30.475c25.674,18.57,49.556,91.9,49.556,91.9v37.143h-456.748Z" transform="translate(16579.049 19041.307)" fill="url(#linear-gradient)"/></svg>""";
    return SvgPicture.string(rawSvg);
  }

  Widget resultCard(BuildContext context) {
    String cardTitle() {
      return "This is higher than average";
    }

    return Container(
      child: Column(
        children: [
          Text(
            "Your score is:",
            style: cardTitleStyle,
          ),
          Container(
            height: designH(15, context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: designW(220, context),
                height: designW(75, context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          offset: Offset(0, 3),
                          blurRadius: 20)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(designW(10, context)),
                  child: widget.arguments.test.resultBanner,
                ),
              ),
              Container(
                width: designW(10, context),
              ),
              Container(
                width: designW(75, context),
                height: designW(75, context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          offset: Offset(0, 3),
                          blurRadius: 20)
                    ]),
                child: Center(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircularPercentIndicator(
                          radius: designW(32, context),
                          lineWidth: designW(8, context),
                          percent: 0.8,
                          center: Container(),
                          progressColor: widget.arguments.test.themeColor,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "122",
                          style: GoogleFonts.oxygen(
                              fontSize: designW(17, context),
                              fontWeight: FontWeight.bold,
                              color: widget.arguments.test.themeColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: designH(15, context),
          ),
          Expanded(
              child: Container(
            width: designW(305, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(designW(10, context)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      offset: Offset(0, 3),
                      blurRadius: 20)
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: designW(10, context),
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      cardTitle(),
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.only(right: designW(20, context)),
                      child: Container(
                        width: designW(45, context),
                        height: designW(45, context),
                        decoration: BoxDecoration(
                            color: widget.arguments.test.themeColor,
                            borderRadius:
                                BorderRadius.circular(designW(45, context))),
                        child: Center(
                          child: Icon(
                            Icons.thumb_up_sharp,
                            color: Color(0xFFFFCB98),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: designH(15, context),
                ),
                Row(
                  children: [
                    Expanded(child: Container()),
                    LinearPercentIndicator(
                      width: designW(260, context),
                      lineHeight: 8.0,
                      percent: 0.2,
                      progressColor: widget.arguments.test.themeColor,
                      backgroundColor:
                          widget.arguments.test.themeColor.lighten(0.22),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                Container(
                  height: designH(20, context),
                ),
                Text(
                  "Check out your detailed results to learn more.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxygen(
                      color: widget.arguments.test.themeColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
          Container(
            height: designH(15, context),
          ),
        ],
      ),
    );
  }

  Widget suggestionCard(BuildContext context) {
    Widget miniCard(MiniCard card) {
      return Container(
        width: designW(290, context),
        height: designW(290, context) / 4.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(designW(10, context)),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(designW(10, context)),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
                child: card.image,
              ),
            ),
            Text(
              card.title.toUpperCase(),
              style: GoogleFonts.oxygen(
                  fontSize: designW(16, context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Column(
            children: [
              Text(
                "Suggested tests:",
                style: cardTitleStyle,
              ),
              Container(
                height: designH(20, context),
              ),
              Text(
                "Take the following tests to improve yourself:",
                style: GoogleFonts.inter(
                    fontSize: 14, color: const Color(0xFF848588)),
              ),
            ],
          ),
          Container(
            height: designH(10, context),
          ),
          Column(
              children: suggestedTests
                  .map((e) => Padding(
                        padding: EdgeInsets.only(bottom: designH(8, context)),
                        child: miniCard(e),
                      ))
                  .toList())
        ],
      ),
    );
  }

  Widget detailsCard(BuildContext context) {
    Widget StringTile(String text) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: designW(7, context),
            height: designW(7, context),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(designW(7, context)),
                color: Color(0xFFED97A0)),
          ),
          Container(
            width: designW(7, context),
          ),
          Text(text, style: GoogleFonts.inter(fontSize: designW(12, context)))
        ],
      );
    }

    return Container(
      child: Column(
        children: [
          Text("Detailed results:", style: cardTitleStyle),
          Container(
              width: designW(130, context),
              child: Image.asset("assets/img/dResults.png")),
          Container(
            width: designW(295, context),
            child: Text(
              "         These results will include the following information:",
              style: GoogleFonts.inter(
                  fontSize: designW(14, context), color: Color(0xFF848588)),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Container()),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StringTile("Correct Answers"),
                      StringTile("Possible Career Tracks"),
                      StringTile("Mental Strengths"),
                      StringTile("Mental Weaknesses"),
                      StringTile("More...")
                    ],
                  ),
                ],
              ),
              Container(
                width: designW(25, context),
              ),
              Container(
                width: designW(100, context),
                height: designW(100, context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 20)
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: designH(15, context), bottom: designH(15, context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Unlock",
                        style: GoogleFonts.inter(
                            fontSize: designW(12, context),
                            fontWeight: FontWeight.bold),
                      ),
                      FlutterSwitch(
                        width: designW(85, context),
                        height: designW(85, context) / 2.4,
                        valueFontSize: designW(14, context),
                        toggleSize: 25,
                        activeText: "PRO",
                        inactiveText: "PRO",
                        inactiveColor: Color(0xFFEDEDED),
                        inactiveTextColor: Color(0xff848588),
                        activeTextColor: Colors.white,
                        activeColor: Color(0xFF35CFA3).withOpacity(0.65),
                        value: detailSwitchStatus,
                        borderRadius: designW(85, context),
                        padding: 8.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            detailSwitchStatus = val;
                          });
                        },
                      ),
                      Text(
                        "right now!",
                        style: GoogleFonts.inter(
                            fontSize: designW(12, context),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height:
                      MediaQuery.of(context).padding.top + designH(20, context),
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
                        child: const Icon(Icons.arrow_back)),
                    Container(
                      width: designW(15, context),
                    ),
                    Text(
                      "Results",
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
                loadSVG()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: designH(190, context),
                ),
                Container(
                  width: designW(340, context),
                  height: designH(460, context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(designW(10, context)),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(3, 3),
                            blurRadius: 20)
                      ]),
                  child: Column(
                    children: [
                      Container(height: designH(10, context)),
                      Expanded(
                          child: Container(
                        child: ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: PageView(
                            controller: _controller,
                            children: [
                              resultCard(context),
                              suggestionCard(context),
                              detailsCard(context),
                            ],
                          ),
                        ),
                      )),
                      SmoothPageIndicator(
                          controller: _controller, // PageController
                          count: 3,
                          effect: const ExpandingDotsEffect(
                              activeDotColor: Color(0xFF7BA7E8),
                              expansionFactor: 2,
                              dotColor:
                                  Color(0xFFE4EDFA)), // your preferred effect
                          onDotClicked: (index) {}),
                      Padding(
                        padding: EdgeInsets.all(designW(15, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: designH(35, context),
                              child: Center(
                                  child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Share",
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    width: designW(6, context),
                                  ),
                                  Icon(
                                    Icons.share,
                                    size: 18,
                                  ),
                                ],
                              )),
                            ),
                            GestureDetector(
                              onTap: () {
                                _controller.animateToPage(2,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceIn);
                              },
                              child: Container(
                                  height: designH(35, context),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Detailed Results",
                                          style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          width: designW(6, context),
                                        ),
                                        Icon(
                                          Icons.analytics_outlined,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_controller.page == 2) {
                                  Navigator.popUntil(
                                      context, ModalRoute.withName(testRoute));
                                }

                                _controller.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.bounceIn);
                              },
                              child: Container(
                                height: designH(35, context),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Next",
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: designW(6, context),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
