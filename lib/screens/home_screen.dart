import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/sliders.dart';
import 'package:e_learning/providers/teachers.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/app_navigation.dart';
import 'package:e_learning/widgets/carousel_slider_widget.dart';
import 'package:e_learning/widgets/teacher_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    // ==TODO: implement initState
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Sliders>(context, listen: false).fetchSlides().then((_){
        if (mounted) {
          Provider.of<Teachers>(context, listen: false).fetchTeachers().then((_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }).catchError((onError) => onError);
        }
      }).catchError((onError) => onError);
    });
  }
  @override
  Widget build(BuildContext context) {
    final teachers = Provider.of<Teachers>(context,listen: false).teachers;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: MyAppBar(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (_isLoading == true)? loadingStyle(context) : const CarouselSliderWidget(),
              screenStartWidget(context,_isLoading,items: teachers,buildWidget: Column(
                children: [
                  Container(
                    width: context.screenWidth,
                    margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                    child: Text("قائمة المعلمين:",
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: teachers[i],
                      child: const TeacherItem(),
                    ),
                    itemCount: teachers.length,
                  ),
                ],
              ),),
            ],
          ),
        ),
        bottomNavigationBar: const AppNavigation(index: 0),
      ),
    );
  }
}
