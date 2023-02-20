import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/auth.dart';
import 'package:e_learning/providers/message.dart';
import 'package:e_learning/providers/messages.dart';
import 'package:e_learning/providers/teachers.dart';
import 'package:e_learning/widgets/chat_app_bar.dart';
import 'package:e_learning/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class ChatRoomScreen extends StatefulWidget {
  static const routeName = "/chat-room";
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Message(content: "", id: 0, roomId: 0, senderId: 0, time: "",senderName: "")),
        ChangeNotifierProvider(create: (_) => Messages()),
      ],
      child: const ChatRoomScreen1(),
    );
  }
}

class ChatRoomScreen1 extends StatefulWidget {
  const ChatRoomScreen1({Key? key}) : super(key: key);
  @override
  ChatRoomScreen1State createState() => ChatRoomScreen1State();
}

class ChatRoomScreen1State extends State<ChatRoomScreen1> {
  bool _isLoading = false;
  TextEditingController msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  late int teachId;

  @override
  void initState() {
    // ==TODO: implement initState
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var teacherId = ModalRoute.of(context)!.settings.arguments as int;
      teachId = teacherId;
      onConnectPressed(teacherId);
      Provider.of<Messages>(context, listen: false).fetchMessages(teacherId: teacherId).then((_) {
       /// scrollDown();
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((onError) => onError);
    });
  }

  void onConnectPressed(teacherId) async {
    try {
      await pusher.init(
        apiKey: "ec7cfae54b4580d00b85",
        cluster: "mt1",
        onEvent: onEvent,
      );
      await pusher.subscribe(
        channelName: "my-channel$teacherId",
      );
      await pusher.connect();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  var arrEvents = [];

  void onEvent(PusherEvent event) {
    print(event.channelName);
    if (!arrEvents.contains(event.data['id']) &&
        event.channelName == "my-channel$teachId") {
      arrEvents.add(event.data['id']);
      //Provider.of<Messages>(context, listen: false).receiveMessage(content: event.data['name']).then((_) {
      Provider.of<Messages>(context, listen: false)
          .receiveMessage(data: event.data)
          .then((_) {
        scrollDown();
      });
    }
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 300,
      duration: const Duration(
        milliseconds: 200,
      ),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<Messages>(context).messages;
    final itemId = ModalRoute.of(context)!.settings.arguments as int;
    final teacher = Provider.of<Teachers>(context, listen: false).findById(itemId);
    final authId = Provider.of<Auth>(context, listen: false).userId;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
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
                    onPressed: () => scrollDown(),
                    //icon: Icon(Icons.menu),
                    icon: const Icon(FontAwesomeIcons.arrowsRotate),
                  ),
                  Text("غرفة:${teacher.name}"),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(FontAwesomeIcons.angleLeft),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: context.screenWidth * 0.9,
            child: Column(
              children: [
                screenStartWidget(context, _isLoading,
                    items: messages,
                    buildWidget: Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: messages[i],
                          child: const MessageItem(),
                        ),
                        itemCount: messages.length,
                      ),
                    )),
                Container(
                  //width: context.screenWidth * 0.95,
                  margin: const EdgeInsets.only(bottom: 3),
                  alignment: Alignment.bottomCenter,
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText1,
                    controller: msgController,
                    decoration: InputDecoration(
                      labelText: 'رسالتك',
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2)),
                      suffixIcon: Container(
                        color: const Color.fromRGBO(232, 237, 255, 1),
                        margin: const EdgeInsets.only(left: 5),
                        child: IconButton(
                          //icon: Icon(FontAwesomeIcons.angleLeft,color: Colors.blue,),
                          icon: Icon(
                            FontAwesomeIcons.angleLeft,
                            color: Theme.of(context).backgroundColor,
                          ),
                          onPressed: () async {
                            //AudioPlayer().play(AssetSource('images/message.mp3'));
                            Provider.of<Messages>(context, listen: false)
                                .addMessage(
                                message: msgController.text,
                                senderId: authId,
                                teacherId: teacher.id);
                            setState(() {
                              msgController.text = "";
                            });
                            scrollDown();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'رسالتك مطلوب';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
