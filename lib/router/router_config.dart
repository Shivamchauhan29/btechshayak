import 'package:btechshayak/router/app_checker.dart';
import 'package:btechshayak/screens/addsubject.dart';
import 'package:btechshayak/screens/chatpage.dart';
import 'package:btechshayak/screens/dashboard.dart';
import 'package:btechshayak/screens/forgetpassword.dart';
import 'package:btechshayak/screens/login.dart';
import 'package:btechshayak/screens/signup.dart';
import 'package:btechshayak/screens/subjectdetails.dart';
import 'package:btechshayak/screens/videoplayer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      //initialLocation tells GoRoute
      //r which location to use in first start

      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const AuthChecker(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashBoard(),
        ),
        GoRoute(
          path: '/signup',
          name: 'signup',
          builder: (context, state) => const SignUp(),
        ),
        GoRoute(
          path: '/addsubject',
          name: 'addsubject',
          builder: (context, state) => const AddSubject(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const Login(),
        ),
        GoRoute(
          path: '/forgetpassword',
          name: 'forgetpassword',
          builder: (context, state) => const ForgetPassword(),
        ),
        GoRoute(
          path: '/subjectdetails',
          name: 'subjectdetails',
          builder: (context, state) => SubjectDetails(
            subjectData: state.extra,
          ),
        ),
        GoRoute(
          path: '/community',
          name: 'community',
          builder: (context, state) => ChatPage(
            userName: state.uri.queryParameters['userName'] ?? '',
            groupId: state.uri.queryParameters['groupId'] ?? '',
            groupName: state.uri.queryParameters['groupName'] ?? '',
          ),
        ),
        GoRoute(
          path: '/videoplayer',
          name: 'videoplayer',
          builder: (context, state) => VideoPlayer(
            url: state.uri.queryParameters['url'],
          ),
        ),
      ]);
});
