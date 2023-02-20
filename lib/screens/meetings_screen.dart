import 'package:e_learning/models/main_data.dart';
import 'package:e_learning/providers/meetings.dart';
import 'package:e_learning/widgets/app_bar.dart';
import 'package:e_learning/widgets/app_navigation.dart';
import 'package:e_learning/widgets/meeting_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MeetingsScreen extends StatefulWidget {
  static const routeName = "/meetings";

  const MeetingsScreen({Key? key}) : super(key: key);

  @override
  MeetingsScreenState createState() => MeetingsScreenState();
}

class MeetingsScreenState extends State<MeetingsScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    // ==TODO: implement initState
    super.initState();
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Meetings>(context, listen: false).fetchMeetings().then((_) {
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
    final meetings =
        Provider.of<Meetings>(context, listen: false).publicMeetings;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: PageAppBar(title: "غرف الاجتماعات", elevate: 0.3),
        ),
        body: screenStartWidget(
          context,
          _isLoading,
          items: meetings,
          buildWidget: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: meetings[i],
              child: const MeetingItem(),
            ),
            itemCount: meetings.length,
          ),
        ),
        bottomNavigationBar: const AppNavigation(index: 1),
      ),
    );
  }
}
