import 'package:e_learning/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      elevation: 5.0,
      automaticallyImplyLeading: false, // hides leading widget
      flexibleSpace: Container(
        margin: const EdgeInsets.only(top: 30,bottom: 5),
        child: Center(
          child: Image.asset("assets/images/logo.png",width: 200,),
        ),
      ),
    );
  }
}

class PageAppBar extends StatelessWidget {
  final title;
  final elevate;
  const PageAppBar({Key? key, this.title,this.elevate = 0.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      elevation: elevate,
      automaticallyImplyLeading: false, // hides leading widget
      flexibleSpace: Container(
        margin: const EdgeInsets.only(top: 30,right: 15,left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
              },
              //icon: Icon(Icons.menu),
              icon: const Icon(FontAwesomeIcons.house),
            ),
            Text(title),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FontAwesomeIcons.angleLeft),
            ),
          ],
        ),
      ),
    );
  }
}

