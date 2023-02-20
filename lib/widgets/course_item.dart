import 'package:e_learning/providers/course.dart';
import 'package:e_learning/screens/course_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final course = Provider.of<Course>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CourseDetailScreen.routeName, arguments: course.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromRGBO(121, 85, 72, 0.5),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                child: course.image == ""
                    ? Image.asset(
                        "assets/images/course_avatar.png",
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        course.image,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.video,
                        size: 15,
                      ),
                      Text("  (${course.videosNum}) مقطع مرئي "),
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
