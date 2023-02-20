import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeSoonScreen extends StatefulWidget {
  static const routeName = "/home-soon";

  const HomeSoonScreen({Key? key}) : super(key: key);

  @override
  HomeSoonScreenState createState() => HomeSoonScreenState();
}

class HomeSoonScreenState extends State<HomeSoonScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PageAppBar(title: "غرف الاجتماعات",elevate: 0.5),
        ),
        // body: Center(
        //   child: Column(
        //     children: [
        //       Container(
        //         margin: const EdgeInsets.only(top: 80),
        //           child: Image.asset(
        //         "assets/images/welcome.gif",
        //         width: context.screenWidth * 0.8,
        //       )),
        //       Container(
        //         width: context.screenWidth * 0.8,
        //         margin: const EdgeInsets.only(top: 30),
        //         child: const Text(
        //           "انتظرونا..قريباً",
        //           style: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             fontSize: 30,
        //             color: Colors.blueGrey,
        //           ),
        //           textAlign: TextAlign.center,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(" لا توجد غرف دردشة لديك حتي الآن   "),
              Icon(FontAwesomeIcons.videoSlash),
            ],
          ),
        ),
        bottomNavigationBar: const AppNavigation(index: 1),
      ),
    );
  }
}
