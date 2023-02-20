// import 'dart:async';
// import 'dart:math';
// import 'package:e_learning/providers/courses.dart';
// import 'package:e_learning/providers/video.dart';
// import 'package:e_learning/providers/videos.dart';
// import 'package:e_learning/widgets/app_bar.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:e_learning/models/main_data.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';
//
// class CourseDetailScreen extends StatefulWidget {
//   static const routeName = "/course-detail";
//
//   const CourseDetailScreen({Key? key, required this.clips}) : super(key: key);
//   final List<Video> clips;
//
//   @override
//   CourseDetailScreenState createState() => CourseDetailScreenState();
// }
//
// class CourseDetailScreenState extends State<CourseDetailScreen> {
//   var _controller;
//   var _clips;
//   var _playingIndex = -1;
//   var _disposed = false;
//   var _isFullScreen = false;
//   var _isEndOfClip = false;
//   var _progress = 0.0;
//   var _showingDialog = false;
//   var _timerVisibleControl;
//   double _controlAlpha = 1.0;
//   var _playing = false;
//   var _playingNow = false;
//
//   bool get _isPlaying {
//     return _playing;
//   }
//
//   set _isPlaying(bool value) {
//     _playing = value;
//     _timerVisibleControl?.cancel();
//     if (value) {
//       _timerVisibleControl = Timer(Duration(seconds: 2), () {
//         if (_disposed) return;
//         setState(() {
//           _controlAlpha = 0.0;
//         });
//       });
//     } else {
//       _timerVisibleControl = Timer(Duration(milliseconds: 200), () {
//         if (_disposed) return;
//         setState(() {
//           _controlAlpha = 1.0;
//         });
//       });
//     }
//   }
//
//   void _onTapVideo() {
//     debugPrint("_onTapVideo $_controlAlpha");
//     setState(() {
//       _controlAlpha = _controlAlpha > 0 ? 0 : 1;
//     });
//     _timerVisibleControl?.cancel();
//     _timerVisibleControl = Timer(Duration(seconds: 2), () {
//       if (_isPlaying) {
//         setState(() {
//           _controlAlpha = 0.0;
//         });
//       }
//     });
//   }
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     _isLoading = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<Videos>(context, listen: false).fetchVideos().then((_) {
//         final videos = Provider.of<Videos>(context, listen: false).videos;
//         _clips = videos;
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }).catchError((onError) => print(onError));
//     });
//     Wakelock.enable();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//     _initializeAndPlay(0);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _disposed = true;
//     _timerVisibleControl?.cancel();
//     Wakelock.disable();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//     _exitFullScreen();
//     _controller?.pause(); // mute instantly
//     _controller?.dispose();
//     _controller = null;
//     super.dispose();
//   }
//
//   void _toggleFullscreen() async {
//     if (_isFullScreen) {
//       _exitFullScreen();
//     } else {
//       _enterFullScreen();
//     }
//   }
//
//   void _enterFullScreen() async {
//     debugPrint("enterFullScreen");
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//     await SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
//     if (_disposed) return;
//     setState(() {
//       _isFullScreen = true;
//     });
//   }
//
//   void _exitFullScreen() async {
//     debugPrint("exitFullScreen");
//     await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     if (_disposed) return;
//     setState(() {
//       _isFullScreen = false;
//     });
//   }
//
//   void _initializeAndPlay(int index) async {
//     print("_initializeAndPlay ---------> $index");
//     final clip = _clips[index];
//
//     final controller = VideoPlayerController.network(clip.url);
//
//     final old = _controller;
//     _controller = controller;
//     if (old != null) {
//       old.removeListener(_onControllerUpdated);
//       old.pause();
//       debugPrint("---- old contoller paused.");
//     }
//
//     debugPrint("---- controller changed.");
//     setState(() {});
//
//     controller
//       ..initialize().then((_) {
//         debugPrint("---- controller initialized");
//         old?.dispose();
//         _playingIndex = index;
//         _duration = null;
//         _position = null;
//         controller.addListener(_onControllerUpdated);
//         controller.play();
//         setState(() {});
//       });
//   }
//
//   var _updateProgressInterval = 0.0;
//   var _duration;
//   var _position;
//
//   void _onControllerUpdated() async {
//     if (_disposed) return;
//     // blocking too many updation
//     // important !!
//     final now = DateTime.now().millisecondsSinceEpoch;
//     if (_updateProgressInterval > now) {
//       return;
//     }
//     _updateProgressInterval = now + 500.0;
//
//     final controller = _controller;
//     if (controller == null) return;
//     if (!controller.value.isInitialized) return;
//     if (_duration == null) {
//       _duration = _controller.value.duration;
//     }
//     var duration = _duration;
//     if (duration == null) return;
//
//     var position = await controller.position;
//     _position = position;
//     final playing = controller.value.isPlaying;
//     final isEndOfClip = position.inMilliseconds > 0 &&
//         position.inSeconds + 1 >= duration.inSeconds;
//     if (playing) {
//       // handle progress indicator
//       if (_disposed) return;
//       setState(() {
//         _progress = position.inMilliseconds.ceilToDouble() /
//             duration.inMilliseconds.ceilToDouble();
//       });
//     }
//
//     // handle clip end
//     if (_isPlaying != playing || _isEndOfClip != isEndOfClip) {
//       _isPlaying = playing;
//       _isEndOfClip = isEndOfClip;
//       debugPrint(
//           "updated -----> isPlaying=$playing / isEndOfClip=$isEndOfClip");
//       if (isEndOfClip && !playing) {
//         debugPrint(
//             "========================== End of Clip / Handle NEXT ========================== ");
//         final isComplete = _playingIndex == _clips.length - 1;
//         if (isComplete) {
//           print("played all!!");
//           if (!_showingDialog) {
//             _showingDialog = true;
//             _showPlayedAllDialog().then((value) {
//               _exitFullScreen();
//               _showingDialog = false;
//             });
//           }
//         } else {
//           _initializeAndPlay(_playingIndex + 1);
//         }
//       }
//     }
//   }
//
//   Future<Future<bool?>> _showPlayedAllDialog() async {
//     return showDialog<bool>(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: SingleChildScrollView(child: Text("Played all videos.")),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final itemId = ModalRoute.of(context)!.settings.arguments as int;
//     final course =
//         Provider.of<Courses>(context, listen: false).findById(itemId);
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: _isFullScreen
//             ? null
//             : PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: PageAppBar(title: course.name),
//         ),
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _isFullScreen
//                 ? Container(
//                     decoration: const BoxDecoration(color: Colors.black),
//                     child: Center(child: _playView(context)),
//                   )
//                 : SingleChildScrollView(
//                   child: Column(children: <Widget>[
//           _playingNow
//                           ? Container(
//                               decoration: const BoxDecoration(color: Colors.black),
//                               child: Center(child: _playView(context)),
//                             )
//                           : Stack(
//                               children: [
//                                 Image.asset(
//                                   "assets/images/header.jpg",
//                                   fit: BoxFit.cover,
//                                 ),
//                                 Center(
//                                   child: Container(
//                                     width: context.screenWidth * 0.80,
//                                     margin: EdgeInsets.only(top: context.screenHeight * 0.17),
//                                     color: Colors.black54,
//                                     padding: EdgeInsets.all(10),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           child: Text(course.name,
//                                             style: TextStyle(
//                                               fontSize: 26,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                             softWrap: true,
//                                           ),
//                                         ),
//                                         Container(
//                                           width: 250,
//                                           color:
//                                           Theme.of(context).backgroundColor,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     FontAwesomeIcons.clock,
//                                                     size: 15,
//                                                     color: Colors.white,
//                                                   ),
//                                                   Text(
//                                                     " 50 د ",
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Icon(
//                                                     FontAwesomeIcons.video,
//                                                     size: 15,
//                                                     color: Colors.white,
//                                                   ),
//                                                   Text(
//                                                     "  (${course.videosNum}) فيديو ",
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                       Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: context.screenWidth,
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 25.0, vertical: 10),
//                               child: Text(
//                                 "وصف الدورة:",
//                                 style: Theme.of(context).textTheme.headline4,
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                             Container(
//                               width: context.screenWidth,
//                               margin: const EdgeInsets.symmetric(
//                                 horizontal: 25.0,
//                               ),
//                               child: Text(
//                                 "مدرس اول لغة عربية ومتخصص في النحو مدرس اول لغة عربية ومتخصص في النحو مدرس اول لغة عربية ومتخصص في النحو ",
//                                 style: Theme.of(context).textTheme.bodyText2,
//                                 textAlign: TextAlign.start,
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             ListView.builder(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding:
//                                   EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                               itemCount: _clips.length,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return _buildCard(index);
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]),
//                 ),
//       ),
//     );
//   }
//
//   Widget _playView(BuildContext context) {
//     final controller = _controller;
//     if (controller != null && controller.value.isInitialized) {
//       return Directionality(
//         textDirection: TextDirection.ltr,
//         child: AspectRatio(
//           //aspectRatio: controller.value.aspectRatio,
//           aspectRatio: 16.0 / 9.0,
//           child: Stack(
//             children: <Widget>[
//               GestureDetector(
//                 child: VideoPlayer(controller),
//                 onTap: _onTapVideo,
//               ),
//               _controlAlpha > 0
//                   ? AnimatedOpacity(
//                       opacity: _controlAlpha,
//                       duration: Duration(milliseconds: 250),
//                       child: _controlView(context),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       );
//     } else {
//       // return AspectRatio(
//       //   aspectRatio: 16.0 / 9.0,
//       //   child: Center(
//       //       child: Text(
//       //     "Preparing ...",
//       //     style: TextStyle(
//       //         color: Colors.white70,
//       //         fontWeight: FontWeight.bold,
//       //         fontSize: 18.0),
//       //   )),
//       // );
//       return AspectRatio(
//         aspectRatio: 16.0 / 9.0,
//         child: Center(
//             child: Container(
//               color: Colors.transparent,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   Text(
//                     "...جارٍ التحميل",
//                     style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 18.0),
//                   ),
//                 ],
//               ),
//             )),
//       );
//     }
//   }
//
//   Widget _controlView(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         _topUI(),
//         Expanded(
//           child: _centerUI(),
//         ),
//         _bottomUI()
//       ],
//     );
//   }
//
//   Widget _centerUI() {
//     return Center(
//         child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         TextButton(
//           onPressed: () async {
//             final index = _playingIndex - 1;
//             if (index > 0 && _clips.length > 0) {
//               _initializeAndPlay(index);
//             }
//           },
//           child: Icon(
//             Icons.fast_rewind,
//             size: 36.0,
//             color: Colors.white,
//           ),
//         ),
//         TextButton(
//           onPressed: () async {
//             if (_isPlaying) {
//               _controller?.pause();
//               _isPlaying = false;
//             } else {
//               final controller = _controller;
//               if (controller != null) {
//                 final pos = _position?.inSeconds ?? 0;
//                 final dur = _duration?.inSeconds ?? 0;
//                 final isEnd = pos == dur;
//                 if (isEnd) {
//                   _initializeAndPlay(_playingIndex);
//                 } else {
//                   controller.play();
//                 }
//               }
//             }
//             setState(() {});
//           },
//           child: Icon(
//             _isPlaying ? Icons.pause : Icons.play_arrow,
//             size: 56.0,
//             color: Colors.white,
//           ),
//         ),
//         TextButton(
//           onPressed: () async {
//             final index = _playingIndex + 1;
//             if (index < _clips.length - 1) {
//               _initializeAndPlay(index);
//             }
//           },
//           child: Icon(
//             Icons.fast_forward,
//             size: 36.0,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     ));
//   }
//
//   String convertTwo(int value) {
//     return value < 10 ? "0$value" : "$value";
//   }
//
//   Widget _topUI() {
//     final noMute = (_controller.value.volume ?? 0.0) > 0.0;
//     final duration = _duration?.inSeconds ?? 0;
//     final head = _position?.inSeconds ?? 0;
//     final remained = max<int>(0, duration - head);
//     final min = convertTwo(remained ~/ 60.0);
//     final sec = convertTwo(remained % 60);
//     return Row(
//       children: <Widget>[
//         InkWell(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Container(
//                 decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
//                   BoxShadow(
//                       offset: const Offset(0.0, 0.0),
//                       blurRadius: 4.0,
//                       color: Color.fromARGB(50, 0, 0, 0)),
//                 ]),
//                 child: Icon(
//                   noMute ? Icons.volume_up : Icons.volume_off,
//                   color: Colors.white,
//                 )),
//           ),
//           onTap: () {
//             print("noMute$noMute");
//             if (noMute) {
//               _controller?.setVolume(0.0);
//             } else {
//               _controller?.setVolume(1.0);
//             }
//             setState(() {});
//           },
//         ),
//         Expanded(
//           child: Container(),
//         ),
//         Text(
//           "$min:$sec",
//           style: TextStyle(
//             color: Colors.white,
//             shadows: <Shadow>[
//               Shadow(
//                 offset: Offset(0.0, 1.0),
//                 blurRadius: 4.0,
//                 color: Color.fromARGB(150, 0, 0, 0),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(width: 10)
//       ],
//     );
//   }
//
//   Widget _bottomUI() {
//     return Row(
//       children: <Widget>[
//         SizedBox(width: 20),
//         Expanded(
//           child: Slider(
//             value: max(0, min(_progress * 100, 100)),
//             min: 0,
//             max: 100,
//             onChanged: (value) {
//               setState(() {
//                 _progress = value * 0.01;
//               });
//             },
//             onChangeStart: (value) {
//               debugPrint("-- onChangeStart $value");
//               _controller?.pause();
//             },
//             onChangeEnd: (value) {
//               debugPrint("-- onChangeEnd $value");
//               final duration = _controller?.value?.duration;
//               if (duration != null) {
//                 var newValue = max(0, min(value, 99)) * 0.01;
//                 var millis = (duration.inMilliseconds * newValue).toInt();
//                 _controller?.seekTo(Duration(milliseconds: millis));
//                 _controller?.play();
//               }
//             },
//           ),
//         ),
//         IconButton(
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: Colors.yellow,
//           icon: Icon(
//             Icons.fullscreen,
//             color: Colors.white,
//           ),
//           onPressed: _toggleFullscreen,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCard(int index) {
//     final clip = _clips[index];
//     final playing = index == _playingIndex;
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Theme.of(context).backgroundColor,
//                 child: Text(
//                   "# ${index + 1}",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(right: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       clip.title,
//                       style: Theme.of(context).textTheme.headline1,
//                     ),
//                     Container(
//                       margin: EdgeInsets.only(right: 10),
//                       child: Text(
//                         "${clip.time} د ",
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               //color: Color.fromRGBO(231, 36, 25, 1.0),
//               color: playing ? Colors.red : Theme.of(context).backgroundColor,
//             ),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   _playingNow = true;
//                 });
//                 _initializeAndPlay(index);
//               },
//               icon: Icon(
//                 FontAwesomeIcons.play,
//                 color: Colors.white,
//                 size: 15,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
