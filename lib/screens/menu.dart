import 'package:btechshayak/router/app_checker.dart';
import 'package:btechshayak/screens/dashboard.dart';
import 'package:btechshayak/service/titleCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final studentName = ref.watch(studentNameProvider);
    final studentData = ref.watch(userDataProvider);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 34, 87, 36),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    height: 60,
                    width: 60,
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        './assets/logo.png',
                        height: 60, // Adjust the logo height as needed
                        width: 80, // Adjust the logo width as needed
                      ),
                    ),
                  ),
                ),

                // Adjust the spacing between logo and student name
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Hello, $studentName',
                  style: const TextStyle(
                    fontFamily: 'times new roman',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '${titleCase(studentData[0])} Year | ${titleCase(studentData[1])}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            onTap: () {
              context.go('/');
            },
          ),
          ListTile(
            title: const Text('Add Subject'),
            leading: const Icon(Icons.subject),
            onTap: () {
              context.go('/addsubject');
            },
          ),
          ListTile(
            title: const Text('Community'),
            leading: const Icon(Icons.local_library),
            onTap: () {
              context.go('/community');
            },
          ),
          ListTile(
            title: const Text('Feedback'),
            leading: const Icon(Icons.feedback),
            onTap: () {
              context.go('/feedback');
            },
          ),
          // ListTile(
          //   title: const Text('About'),
          //   onTap: () {
          //     context.go('about');
          //   },
          // ),
        ],
      ),
    );
  }
}
