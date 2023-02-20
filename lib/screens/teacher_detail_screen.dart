import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/course.dart';
import 'package:e_learning/providers/courses.dart';
import 'package:e_learning/providers/teachers.dart';
import 'package:e_learning/screens/chat_room_screen.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/course_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TeacherDetailScreen extends StatefulWidget {
  static const routeName = "/teacher-detail";
  const TeacherDetailScreen({Key? key}) : super(key: key);
  @override
  TeacherDetailScreenState createState() => TeacherDetailScreenState();
}

class TeacherDetailScreenState extends State<TeacherDetailScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    // ==TODO: implement initState
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemId = ModalRoute.of(context)!.settings.arguments as int;
      Provider.of<Courses>(context, listen: false).fetchCourses(teacherId: itemId).then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((onError) => onError);
    });
  }
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as int;
    final teacher = Provider.of<Teachers>(context, listen: false).findById(itemId);
    final courses = Provider.of<Courses>(context,listen: false).courses;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: PageAppBar(title: teacher.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: context.screenHeight * 0.30,
                    width: double.infinity,
                    child: teacher.cover == "" ? Image.asset(
                      "assets/images/header.jpg",
                      fit: BoxFit.cover,
                    ) : Image.network(
                      teacher.cover,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: context.screenWidth * 0.80,
                      margin: EdgeInsets.only(top: context.screenHeight * 0.16),
                      padding: const EdgeInsets.only(bottom: 5),
                      color: Colors.black54,
                      child: Column(
                        children: [
                          Text(
                            teacher.name,
                            style: const TextStyle(
                              fontSize: 26,
                              color: Colors.white,
                            ),
                            softWrap: true,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            color: const Color.fromRGBO(173, 212, 97,1),
                            child: Text(teacher.subject,
                              style: const TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: context.screenWidth,
                margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
                child: Text("نبذة عن المعلم:",
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                width: context.screenWidth,
                margin: const EdgeInsets.symmetric(horizontal: 25.0,),
                child: Text((teacher.description == "")? "لا توجد بيانات متاحة": teacher.description,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 15),
              screenStartWidget(context,_isLoading,items: courses,buildWidget: Column(
                children: [
                  Container(
                    width: context.screenWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                    child: Text(" المقاطع المرئية: (${teacher.coursesNumber}) ",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: courses[i],
                      child: const CourseItem(),
                    ),
                    itemCount: courses.length,
                  ),
                ],
              ),),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).backgroundColor,
          onPressed: ()=>Navigator.of(context).pushNamed(ChatRoomScreen.routeName,arguments: teacher.id),
          child: const Icon(FontAwesomeIcons.message),
        ),
      ),
    );
  }
}
