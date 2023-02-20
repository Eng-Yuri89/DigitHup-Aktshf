import 'dart:async';
import 'dart:math';
import 'package:e_learning/providers/courses.dart';
import 'package:e_learning/providers/video.dart';
import 'package:e_learning/providers/videos.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/video_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:e_learning/models/main_data.dart';

class CourseDetailScreen extends StatefulWidget {
  static const routeName = "/course-detail";

  const CourseDetailScreen({Key? key}) : super(key: key);

  @override
  CourseDetailScreenState createState() => CourseDetailScreenState();
}

class CourseDetailScreenState extends State<CourseDetailScreen> {
  var playingIndex = -1;
  bool _isLoading = false;
  int vimeoVideoId = 70591644;

  @override
  void initState() {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemId = ModalRoute.of(context)!.settings.arguments as int;
      Provider.of<Videos>(context, listen: false)
          .fetchVideos(courseId: itemId)
          .then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((onError) => onError);
    });
    super.initState();
  }

  void _initializeAndPlay(int index) async {
    final videos = Provider.of<Videos>(context, listen: false).videos;
    final video = videos[index];
    setState(() {
      //vimeoVideoId = video.id;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return VideoWidget(videoId: int.parse(video.ipVideo));
      }));
      playingIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as int;
    final course =
        Provider.of<Courses>(context, listen: false).findById(itemId);
    final videos = Provider.of<Videos>(context, listen: false).videos;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: PageAppBar(title: course.name),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                  Stack(
                    children: [
                      SizedBox(
                        height: context.screenHeight * 0.30,
                        width: double.infinity,
                        child: course.cover == "" ? Image.asset(
                          "assets/images/header.jpg",
                          fit: BoxFit.cover,
                        ) : Image.network(
                          course.cover,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: context.screenWidth * 0.80,
                          margin:
                              EdgeInsets.only(top: context.screenHeight * 0.17),
                          color: Colors.black54,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                course.name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                              Container(
                                width: 250,
                                color: Theme.of(context).backgroundColor,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    /*Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.clock,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          " 50 د ",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),*/
                                    Row(
                                      children:[
                                         const Icon(
                                          FontAwesomeIcons.video,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          "  (${videos.length}) مقطع مرئي ",
                                          style:  const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      children: [
                        Container(
                          width: context.screenWidth,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 10),
                          child: Text(
                            "وصف الدورة:",
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          width: context.screenWidth,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 25.0,
                          ),
                          child: Text(course.description,style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 60),
                          //height: context.screenHeight - 400,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            itemCount: videos.length,
                            itemBuilder: (BuildContext context, int index) {
                              var video = videos[index];
                              final playing = index == playingIndex;
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).backgroundColor,
                                          child: Text(
                                            "# ${index + 1}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                video.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1,
                                              ),
                                              // Container(
                                              //   margin: const EdgeInsets.only(right: 10),
                                              //   child: Text(
                                              //     "${video.time} د ",
                                              //     style: Theme.of(context).textTheme.headline6,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        //color: Color.fromRGBO(231, 36, 25, 1.0),
                                        color: playing
                                            ? Colors.red
                                            : Theme.of(context).backgroundColor,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          _initializeAndPlay(index);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.play,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
      ),
    );
  }
}
