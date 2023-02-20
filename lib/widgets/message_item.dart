import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/providers/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final message = Provider.of<Message>(context, listen: false);
    final authId  = Provider.of<Auth>(context, listen: false).userId;
    return Row(
      mainAxisAlignment: message.senderId == authId ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
         Container(
           margin: const EdgeInsets.symmetric(vertical: 10),
           constraints: BoxConstraints(
             minWidth: context.screenWidth * 0.1,
             maxWidth: context.screenWidth * 0.8,
           ),
           child: Card(
            color: message.senderId == authId ? Theme.of(context).backgroundColor : const Color.fromRGBO(235, 235, 235,1),
            child:  Padding(
              padding:  const EdgeInsets.all(7.0),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:[
                  if(message.senderId != authId)
                    Text(":${message.senderName}",style: TextStyle(color: Color.fromRGBO(69, 104, 61,1)),),
                  Text(message.content,style: TextStyle(color: Colors.black),),
                  Text(message.time,style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
        ),
         ),
      ],
    );
  }
}
