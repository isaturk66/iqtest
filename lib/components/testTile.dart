import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqtest/algorithms/uihelpers.dart';
import 'package:iqtest/constants/contentConstants.dart';
import 'package:iqtest/constants/routeConstants.dart';
import 'package:iqtest/constants/stateConstants.dart';
import 'package:iqtest/pages/homePage.dart';
import 'package:iqtest/states/UIState.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TestTileData {
  final String img, title, desc;

  const TestTileData(
      {required this.img, required this.title, required this.desc});
}

class CardBodyTileData {
  final double percent;
  final String title, asset, desc;

  CardBodyTileData(
      {required this.percent,
      required this.title,
      required this.asset,
      required this.desc});
}

class ExpandedCardBodyTile extends StatelessWidget {
  const ExpandedCardBodyTile(
      {Key? key,
      required this.data,
      required this.size,
      required this.uuid,
      required this.parentContext})
      : super(key: key);

  final CardBodyTileData data;
  final Size size;
  final uuid;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    var contentStyle = GoogleFonts.inter(
        fontSize: designW(14, context), color: Color(0xFF848588));
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(designW(10, context))),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: designH(10, context),
              bottom: designH(35, context),
            ),
            child: Container(
                width: designW(290, context),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(designW(10, context)),
                    child: Hero(tag: uuid, child: Image.asset(data.asset)))),
          ),
          Text(
            data.title,
            style: GoogleFonts.inter(fontSize: designW(26, context)),
          ),
          SizedBox(height: designH(20, context)),
          Container(
            width: designW(300, context),
            child: Text(
              data.desc,
              style: GoogleFonts.inter(
                  fontSize: designW(14, context), color: Color(0xFF848588)),
            ),
          ),
          Expanded(child: Container()),
          Container(
            width: size.width * 0.93,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "30 mins test",
                  style: contentStyle,
                ),
                Text(
                  "13/50",
                  style: contentStyle,
                )
              ],
            ),
          ),
          SizedBox(height: designH(8, context)),
          Stack(
            children: [
              Container(
                width: size.width * 0.93,
                height: (size.width * 0.93) / 28,
                decoration: BoxDecoration(
                    color: Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(size.height / 18)),
              ),
              Container(
                width: (size.width * 0.93) * data.percent,
                height: (size.width * 0.93) / 28,
                decoration: BoxDecoration(
                    color: Color(0xFF7BA7E8),
                    borderRadius: BorderRadius.circular(size.height / 18)),
              ),
            ],
          ),
          SizedBox(height: designH(15, context)),
          GestureDetector(
            onTap: () {
              Navigator.of(parentContext)
                  .pushNamed(testRoute, arguments: IQTEST);
            },
            child: Container(
              width: designW(200, context),
              height: designW(200, context) / 5,
              decoration: BoxDecoration(
                color: Color(0xFF7BA7E8),
                borderRadius: BorderRadius.circular(designW(200, context) / 10),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(3, 3))
                ],
              ),
              child: Center(
                child: Text("Start Test",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: designW(16, context),
                        color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: designH(25, context)),
        ],
      ),
    );
  }
}

class CardBodyTile extends StatefulWidget {
  const CardBodyTile({Key? key, required this.size, required this.data})
      : super(key: key);
  final Size size;
  final CardBodyTileData data;

  @override
  State<CardBodyTile> createState() => _CardBodyTileState();
}

class _CardBodyTileState extends State<CardBodyTile> {
  late final uuid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uuid = Uuid();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //_controller.forward();
        SmartDialog.show(builder: (cont) {
          return ExpandedCardBodyTile(
              parentContext: context,
              uuid: uuid,
              data: widget.data,
              size: Size(designW(355, context), designH(550, context)));
        });
      },
      child: Container(
        width: widget.size.width,
        height: widget.size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(0.08),
                  offset: Offset(3, 3))
            ],
            borderRadius: BorderRadius.circular(widget.size.height / 15)),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(
                    top: designW(10, context),
                    left: designW(10, context),
                    right: designW(10, context),
                    bottom: designH(5, context)),
                child: Hero(tag: uuid, child: Image.asset(widget.data.asset))),
            Text(widget.data.title),
            Container(
              height: designH(5, context),
            ),
            Stack(
              children: [
                Container(
                  width: widget.size.width * 0.93,
                  height: widget.size.height / 9,
                  decoration: BoxDecoration(
                      color: Color(0xFFEDEDED),
                      borderRadius:
                          BorderRadius.circular(widget.size.height / 18)),
                ),
                Container(
                  width: (widget.size.width * 0.93) * widget.data.percent,
                  height: widget.size.height / 9,
                  decoration: BoxDecoration(
                      color: Color(0xFF7BA7E8),
                      borderRadius:
                          BorderRadius.circular(widget.size.height / 18)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TestTile extends StatefulWidget {
  const TestTile({Key? key, required this.data, required this.index})
      : super(key: key);
  final TestTileData data;
  final int index;

  @override
  State<TestTile> createState() => _TestTileState();
}

class _TestTileState extends State<TestTile> {
  double minHeight = 0;
  double titleOppacity = 0;

  double _begin = 3.0;
  double _end = 0.0;
  bool extended = false;

  var cards = [
    CardBodyTileData(
        percent: 0.2,
        title: "Depression",
        asset: "assets/img/cardBodyBanner.png",
        desc:
            "      The Myers–Briggs Type Indicator (MBTI) is an introspective self-report questionnaire indicating differing psychological preferences in how people perceive the world and make decisions. The test attempts to assign four categories: introversion or extraversion, sensing or intuition, thinking or feeling, judging or perceiving."),
    CardBodyTileData(
        percent: 0.65,
        title: "Depression",
        asset: "assets/img/cardBodyBanner.png",
        desc:
            "      The Myers–Briggs Type Indicator (MBTI) is an introspective self-report questionnaire indicating differing psychological preferences in how people perceive the world and make decisions. The test attempts to assign four categories: introversion or extraversion, sensing or intuition, thinking or feeling, judging or perceiving."),
    CardBodyTileData(
        percent: 0.3,
        title: "Depression",
        asset: "assets/img/cardBodyBanner.png",
        desc:
            "      The Myers–Briggs Type Indicator (MBTI) is an introspective self-report questionnaire indicating differing psychological preferences in how people perceive the world and make decisions. The test attempts to assign four categories: introversion or extraversion, sensing or intuition, thinking or feeling, judging or perceiving.")
  ];

  Widget tileBody() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: designW(18, context)),
          child: Text(
            widget.data.title,
            style: GoogleFonts.oxygen(
                fontSize: designH(16, context),
                color: const Color(0xFF848588),
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: designW(18, context)),
          child: Text(
            "3/6",
            style: GoogleFonts.oxygen(
                color: const Color(0xFF848588),
                fontSize: designH(16, context),
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget cardBody() {
    return Container(
      height: designH(400, context),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: designW(30, context),
              right: designW(30, context),
            ),
            child: Text(
              widget.data.desc,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: designW(14, context), color: Color(0xFF848588)),
            ),
          ),
          Container(
            height: designH(10, context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  children: cards
                      .map((e) => Padding(
                            padding:
                                EdgeInsets.only(bottom: designH(15, context)),
                            child: CardBodyTile(
                                data: e,
                                size: Size(designW(315, context),
                                    designH(160, context))),
                          ))
                      .toList()),
            ),
          )
        ],
      ),
    );
  }

  /*
   */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!extended) {
          var uistate = context.read<UIState>();
          uistate.headerState = HeaderState.expandedTileState;
          uistate.backButtonCallback = () {
            if (!mounted) return;

            setState(() {
              minHeight = 0;
              titleOppacity = 0;
              _begin = 3.0;
              _end = 0.0;
              extended = false;
            });
            uistate.headerState = HeaderState.homeState;
            var ancestralState = context.findAncestorStateOfType<HomeState>();
            ancestralState?.setScrollable();
            print(ancestralState?.scrollPhysics);
            uistate.notifyListeners();
          };
          uistate.notifyListeners();
          var ancestralState = context.findAncestorStateOfType<HomeState>();
          ancestralState?.scrollController.scrollTo(
              index: widget.index, duration: Duration(milliseconds: 100));

          setState(() {
            minHeight = designH(530, context);
            titleOppacity = 1;
            _begin = 0.0;
            _end = 3.0;
          });
        }
      },
      child: AnimatedContainer(
        onEnd: () {
          if (minHeight != 0) {
            var ancestralState = context.findAncestorStateOfType<HomeState>();
            ancestralState?.scrollController
                .scrollTo(
                    index: widget.index, duration: Duration(milliseconds: 100))
                .then((value) => ancestralState.setNeverScrollable());
            setState(() {
              extended = true;
            });
          }
        },
        duration: Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: 15000,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(designH(13, context)),
            color: const Color(0xFFEFEFEF),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 15, offset: Offset(0, 3))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(designW(8, context)),
              child: Container(
                  width: designW(340, context),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius:
                              BorderRadius.circular(designH(10, context)),
                          child: Image.asset(widget.data.img)),
                      TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: _begin, end: _end),
                          duration: const Duration(milliseconds: 500),
                          builder: (_, value, child) {
                            return Positioned.fill(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(designH(10, context)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: BackdropFilter(
                                      key: UniqueKey(),
                                      filter: ImageFilter.blur(
                                          sigmaX: value, sigmaY: value),
                                      child: new Container()),
                                ),
                              ),
                            );
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          )),
                      AnimatedOpacity(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 160),
                        opacity: titleOppacity,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: designH(20, context)),
                            child: Text(
                              widget.data.title,
                              style: GoogleFonts.oxygen(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: designW(4, context), bottom: designW(12, context)),
              child: Container(
                  width: designW(331, context),
                  child: extended ? cardBody() : tileBody()),
            )
          ],
        ),
      ),
    );
  }
}
