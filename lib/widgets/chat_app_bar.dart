import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatAppBar extends StatelessWidget {
  final name;
  final Function func;
  const ChatAppBar({Key? key, this.name,required this.func}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      elevation: 0.8,
      automaticallyImplyLeading: false, // hides leading widget
      flexibleSpace: Container(
        margin: const EdgeInsets.only(top: 40,right: 15,left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => func,
              //icon: Icon(Icons.menu),
              icon: const Icon(FontAwesomeIcons.ellipsisVertical),
            ),
            Text("غرفة:$name"),
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
