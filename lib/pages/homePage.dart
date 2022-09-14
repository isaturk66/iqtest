import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqtest/algorithms/uihelpers.dart';
import 'package:iqtest/components/testTile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  static const tests = [
    TestTileData(
        img: "assets/img/testTileBanner.png",
        title: "IQ TEST",
        desc:
            "Multiple IQ testing options that measure IQ in the following way"),
    TestTileData(
        img: "assets/img/testTileBanner.png",
        title: "PERSONALITY TEST",
        desc:
            "Multiple IQ testing options that measure IQ in the following way"),
    TestTileData(
        img: "assets/img/testTileBanner.png",
        title: "MENTAL HEALTH",
        desc:
            "Multiple IQ testing options that measure IQ in the following way"),
    TestTileData(
        img: "assets/img/testTileBanner.png",
        title: "EMOTIONAL TEST",
        desc:
            "Multiple IQ testing options that measure IQ in the following way"),
    TestTileData(
        img: "assets/img/testTileBanner.png",
        title: "STUFF TEST",
        desc:
            "Multiple IQ testing options that measure IQ in the following way"),
  ];

  ItemScrollController scrollController = ItemScrollController();

  var scrollPhysics;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      scrollController.scrollTo(index: 0, duration: Duration(milliseconds: 10));
    });
  }

  void setNeverScrollable() {
    setState(() {
      scrollPhysics = const NeverScrollableScrollPhysics();
    });
  }

  void setScrollable() {
    setState(() {
      scrollPhysics = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          //Background
          Column(
            children: [
              Container(
                color: Colors.white,
                height: designH(100, context),
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF1A66D8).withOpacity(0.10),
                ),
              ),
            ],
          ),

          Column(
            children: [
              Expanded(
                  child: ScrollablePositionedList.builder(
                physics: scrollPhysics,
                itemScrollController: scrollController,
                itemCount: tests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: designW(10, context),
                        right: designW(10, context),
                        bottom: designH(20, context)),
                    child: TestTile(
                      index: index,
                      data: tests[index],
                    ),
                  );
                },
              ))
            ],
          )
        ],
      ),
    );
  }
}








    /**
     * SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: tests
                            .map((e) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: designH(20, context)),
                                  child: TestTile(data: e),
                                ))
                            .toList()),
                  ],
                ),
              )
     */