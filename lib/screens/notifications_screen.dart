import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = "/notifications";

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PageAppBar(title: "الإشعارات",elevate: 0.3),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(" لا توجد اشعارات لديك حتي الآن   "),
              Icon(FontAwesomeIcons.bellSlash),
            ],
          ),
        ),
        bottomNavigationBar: const AppNavigation(index: 3),
      ),
    );
  }
}
