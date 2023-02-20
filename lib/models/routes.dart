import 'package:e_learning/screens/auth_screen.dart';
import 'package:e_learning/screens/challenges_screen.dart';
import 'package:e_learning/screens/chat_room_screen.dart';
import 'package:e_learning/screens/course_detail_screen.dart';
import 'package:e_learning/screens/delete_account_screen.dart';
import 'package:e_learning/screens/edit_account_screen.dart';
import 'package:e_learning/screens/home_screen.dart';
import 'package:e_learning/screens/home_screenSoon.dart';
import 'package:e_learning/screens/meetings_screen.dart';
import 'package:e_learning/screens/notifications_screen.dart';
import 'package:e_learning/screens/reset_password_screen.dart';
import 'package:e_learning/screens/teacher_detail_screen.dart';

var routes={
  AuthScreen.routeName: (_) => const AuthScreen(),
  HomeScreen.routeName: (_) => const HomeScreen(),
  TeacherDetailScreen.routeName: (_) => const TeacherDetailScreen(),
  //CourseDetailScreen.routeName: (_) => const CourseDetailScreen(),
  CourseDetailScreen.routeName: (_) => const CourseDetailScreen(),
  ChatRoomScreen.routeName: (_) => const ChatRoomScreen(),
  EditAccountScreen.routeName: (_) => const EditAccountScreen(),
  HomeSoonScreen.routeName: (_) => const HomeSoonScreen(),
  NotificationsScreen.routeName: (_) => const NotificationsScreen(),
  ResetPasswordScreen.routeName: (_) => const ResetPasswordScreen(),
  DeleteAccountScreen.routeName: (_) =>  DeleteAccountScreen(),
  MeetingsScreen.routeName: (_) =>  const MeetingsScreen(),
  ChallengesScreen.routeName: (_) =>  const ChallengesScreen(),
};