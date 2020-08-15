import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:pika_joe/screens/observations_page.dart';
import 'package:pika_joe/styles/colors.dart';
import 'package:pika_joe/styles/styles.dart';
import 'package:pika_joe/widget/drawer/elastic_drawer.dart';
import 'package:pika_joe/widget/drawer/main_drawer.dart';
import 'package:pika_joe/widget/navigation/main_appbar.dart';
import 'package:pika_joe/widget/navigation/main_navbar.dart';

//Derived from https://github.com/iamSahdeep/liquid_swipe_flutter/blob/master/example/lib/main.dart
class HomeWithSidebar extends StatefulWidget {
  @override
  _HomeWithSidebarState createState() => _HomeWithSidebarState();
}

class _HomeWithSidebarState extends State<HomeWithSidebar> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LiquidController liquidController = LiquidController();

  @override
  Widget build(BuildContext context) {
    print('Build home with sidebar');
    Size mediaQuery = MediaQuery.of(context).size;

    List<Widget> pages=[ObservationsPage(),ObservationsPage(),ObservationsPage()];

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: MainAppBar(openMenuCallback: (){ _scaffoldKey.currentState.openDrawer(); }),
      body: Container(
        width: mediaQuery.width,
        child: Stack(
          children: <Widget>[
            PageView.builder(
              itemCount: 3,
              itemBuilder: (context, position) => pages[position],
            ),
            /*LiquidSwipe(
              pages: <Container>[
                ObservationsPage(),
                Page2(),
                Page3(),
              ],
              enableLoop: true,
              fullTransitionValue: 300,
              enableSlideIcon: true,
              waveType: WaveType.liquidReveal,
              positionSlideIcon: 0.5,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
              disableUserGesture: true,
              //TODO - onPageChangeCallback: pageChangeCallback,
            ),*/
          ],
        ),
      ),
      bottomNavigationBar: MainNavbar(),
      drawer: MainDrawer(),
    );
  }
}