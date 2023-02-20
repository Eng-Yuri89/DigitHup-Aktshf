// import 'package:e_learning/models/main_data.dart';
// import 'package:e_learning/models/routes.dart';
// import 'package:e_learning/providers/auth.dart';
// import 'package:e_learning/providers/course.dart';
// import 'package:e_learning/providers/courses.dart';
// import 'package:e_learning/providers/meeting.dart';
// import 'package:e_learning/providers/meetings.dart';
// import 'package:e_learning/providers/message.dart';
// import 'package:e_learning/providers/messages.dart';
// import 'package:e_learning/providers/sliders.dart';
// import 'package:e_learning/providers/teacher.dart';
// import 'package:e_learning/providers/teachers.dart';
// import 'package:e_learning/providers/video.dart';
// import 'package:e_learning/providers/videos.dart';
// import 'package:e_learning/screens/auth_screen.dart';
// import 'package:e_learning/screens/home_screen.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   runApp(const MyHomePage());
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       systemNavigationBarColor: Colors.white,
//     ));
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => Auth()..tryAutoLogin()),
//         ChangeNotifierProvider(create: (_) => Teachers()),
//         ChangeNotifierProvider(create: (_) => Sliders()),
//         // ChangeNotifierProvider(create: (_) => Message(content: "", id: 0, roomId: 0, senderId: 0, time: "",senderName: "")),
//         // ChangeNotifierProvider(create: (_) => Messages()),
//         ChangeNotifierProvider(
//             create: (_) => Teacher(
//                 id: 0, coursesNumber: 0, name: "", subject: "", image: "",description: "",cover: "")),
//         ChangeNotifierProvider(
//             create: (_) => Course(
//                 id: 0, videosNum: 0, name: "", image: "", description: "",cover: "")),
//         ChangeNotifierProvider(create: (_) => Courses()),
//         ChangeNotifierProvider(
//             create: (_) => Video(
//               id: 0, title: "", ipVideo: "", url: "", )),
//         ChangeNotifierProvider(create: (_) => Videos()),
//         ChangeNotifierProvider(create: (_) => Meeting(id: 0,description: '',meetingId: '',password: '',type: '',time: '')),
//         ChangeNotifierProvider(create: (_) => Meetings()),
//       ],
//       child: MaterialApp(
//         title: mainTitle,
//         debugShowCheckedModeBanner: false,
//         theme: lightTheme,
//         home: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Consumer<Auth>(
//             builder: (ctx, auth, _) => (auth.isAuth)
//                 ? const HomeScreen()
//                 : const AuthScreen(),
//           ),
//         ),
//         routes: routes,
//       ),
//     );
//   }
// }
