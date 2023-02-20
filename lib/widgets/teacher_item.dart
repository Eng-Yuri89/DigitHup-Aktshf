import 'package:e_learning/providers/teacher.dart';
import 'package:e_learning/screens/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class TeacherItem extends StatelessWidget {
  const TeacherItem({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final teacher = Provider.of<Teacher>(context, listen: false);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(TeacherDetailScreen.routeName, arguments: teacher.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: ClipRRect(
                child: teacher.image == "" ? Image.asset(
                  "assets/images/teacher_avatar2.png",
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ) : Image.network(
                  teacher.image,
                  height: 110,
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
                  Text(teacher.name,style: Theme.of(context).textTheme.headline1,),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.book,size: 15,),
                      Text(" ${teacher.subject} "),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.solidCirclePlay,size: 15,),
                      Text(" ( ${teacher.coursesNumber} ) مقاطع مرئية "),
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
