import 'package:e_learning/screens/challenges_screen.dart';
import 'package:e_learning/screens/edit_account_screen.dart';
import 'package:e_learning/screens/home_screen.dart';
import 'package:e_learning/screens/home_screenSoon.dart';
import 'package:e_learning/screens/meetings_screen.dart';
import 'package:e_learning/screens/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppNavigation extends StatefulWidget {
  final int index;
  @override
  const AppNavigation({Key? key, required this.index}) : super(key: key);
  @override
  AppNavigationState createState() => AppNavigationState();
}

class AppNavigationState extends State<AppNavigation> {
  @override
  Widget build(BuildContext context) {
    var tabs = [
      HomeScreen.routeName,
      MeetingsScreen.routeName,
      ChallengesScreen.routeName,
      NotificationsScreen.routeName,
      EditAccountScreen.routeName,
    ];
    void _selectPage(int value) {
      Navigator.of(context).pushNamed(tabs[value]);
    }

    bool hasIndex;
    int indexId;
    // ignore: unnecessary_null_comparison
    if (widget.index != null) {
      hasIndex = true;
      indexId = widget.index;
    } else {
      hasIndex = false;
      indexId = 0;
    }
    return BottomNavigationBar(
      elevation: 5.0,
      onTap: _selectPage,
      selectedItemColor:  hasIndex ? Theme.of(context).backgroundColor :  const Color.fromRGBO(102, 102, 102, 1),
      unselectedItemColor:  const Color.fromRGBO(102, 102, 102, 1),
      currentIndex: indexId,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      selectedFontSize: 10,
      unselectedFontSize: 10,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items:  const[
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.video),
          label: "غرف الاجتماعات",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.cameraRetro),
          label: "غرف التحدي",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidBell),
          label: "الإشعارات",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.userGear),
          label: "حسابي",
        ),
      ],
    );
  }
}
