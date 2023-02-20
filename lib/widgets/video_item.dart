import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:e_learning/providers/video.dart';
import 'package:e_learning/screens/course_detail_screen.dart';
import 'package:e_learning/screens/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class VideoItem extends StatelessWidget {
  final  index;
  const VideoItem(this.index, {Key? key}) : super(key: key,);
  @override
  Widget build(BuildContext context) {
    final video = Provider.of<Video>(context, listen: false);
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(CourseDetailScreen.routeName, arguments: course.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: Text("# ${index + 1}",style: TextStyle(color: Colors.white),),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.title, style: Theme
                          .of(context)
                          .textTheme
                          .headline1,),
                      // Container(
                      //   margin: EdgeInsets.only(right: 10),
                      //   child: Text("${video.time} د ", style: Theme
                      //       .of(context)
                      //       .textTheme
                      //       .headline6,),
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
                color: Theme.of(context).backgroundColor,
              ),
              child: IconButton(
                  onPressed: () {print("object");},
                  icon: Icon(FontAwesomeIcons.play,color: Colors.white,size: 15,),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
