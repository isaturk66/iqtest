import 'package:flutter/material.dart';
import 'package:iqtest/algorithms/uihelpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iqtest/constants/stateConstants.dart';
import 'package:iqtest/pages/homePage.dart';
import 'package:iqtest/states/UIState.dart';
import 'package:provider/provider.dart';

class Skeleton extends StatefulWidget {
  const Skeleton({Key? key}) : super(key: key);

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> {
  PageController pageController = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  Widget bottomNavBar() {
    Widget navTile(IconData icon, String title, int index) {
      bool selected = false;
      try {
        selected = pageController.page == index;
      } catch (e) {}

      return GestureDetector(
        onTap: () {
          pageController
              .animateToPage(index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceIn)
              .then((value) => {setState(() {})});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: designH(35, context),
              color: selected ? Color(0xFF7BA7E8) : Color(0xFFD3D1D1),
            ),
            Text(title,
                style: GoogleFonts.inter(
                    color: selected ? Color(0xFF7BA7E8) : Color(0xFFD3D1D1),
                    fontSize: 10))
          ],
        ),
      );
    }

    return Container(
      height: designH(76, context),
      color: Color(0xFF1A66D8).withOpacity(0.10),
      child: Center(
        child: Container(
          width: designW(367, context),
          height: designH(60, context),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(designH(10, context)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              navTile(Icons.home, "Home", 0),
              Expanded(child: Container()),
              navTile(Icons.article_outlined, "All Tests", 1),
              Expanded(child: Container()),
              navTile(Icons.line_axis, "Progress", 2),
              Expanded(child: Container())
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    Widget _headerBody(HeaderState headerState) {
      switch (headerState) {
        case HeaderState.homeState:
          return Align(
            alignment: Alignment.center,
            child: Container(
              width: designW(315, context),
              child: Text(
                "             The All in One test assessment which provides a more detailed info of your IQ, Personality, and even more...",
                style:
                    GoogleFonts.inter(fontSize: 10, color: Color(0xFF848588)),
              ),
            ),
          );
        case HeaderState.expandedTileState:
          return Padding(
            padding: EdgeInsets.only(left: designW(35, context)),
            child: GestureDetector(
              onTap: () {
                context.read<UIState>().backButtonCallback();
              },
              child: Row(
                children: [
                  Text("Back",
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.arrow_back_ios, size: 13)
                ],
              ),
            ),
          );
        default:
          return Container();
      }
    }

    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).padding.top + designH(135, context),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Consumer<UIState>(
          builder: (context, state, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: designH(35, context), left: designW(25, context)),
                  child: Text(
                    state.headerTitle,
                    style: GoogleFonts.oxygen(
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(child: Container()),
                _headerBody(state.headerState),
                SizedBox(
                  height: designH(15, context),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            Expanded(
                child: Container(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Home(),
                  Container(
                    color: Colors.blueAccent,
                  ),
                  Container(
                    color: Colors.greenAccent,
                  )
                ],
              ),
            )),
            bottomNavBar()
          ],
        ),
      ),
    );
  }
}
