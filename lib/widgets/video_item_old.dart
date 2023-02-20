import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/teacher.dart';
import 'package:e_learning/screens/course_detail_screen.dart';
import 'package:e_learning/screens/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class VideoItem extends StatelessWidget {
  const VideoItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);
    return InkWell(
      onTap: () {
       // Navigator.of(context).pushNamed(CourseDetailScreen.routeName, arguments: course.id);
      },
      child: Container(

        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromRGBO(204, 204, 255, 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              child: ClipRRect(
                //borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  course.image,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name,style: Theme.of(context).textTheme.headline1,),
                  Text(course.description,style: Theme.of(context).textTheme.bodyText1,),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.video,size: 12,),
                      Text("${course.videosNum}"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
