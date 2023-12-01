// ignore_for_file: avoid_print

import 'package:btechshayak/router/app_checker.dart';
import 'package:btechshayak/screens/menu.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final studentNameProvider = StateProvider<String>((ref) => '');

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  @override
  Widget build(BuildContext context) {
    final path = ref.watch(userDataProvider);
    print('path: $path');

    void getUser() async {
      final uid = ref.read(authProvider).currentUser?.uid;
      print('uid: $uid');
      print('get User running');
      final userData =
          await ref.read(firestoreProvider).getDocument(path: 'users/$uid');
      final user = userData.data();
      ref.read(studentNameProvider.notifier).state = user['fullName'];

      ref.read(userDataProvider.notifier).state[0] = user['year'];
      ref.read(userDataProvider.notifier).state[1] = user['branch'];
      ref.read(userDataProvider.notifier).state[2] = user['email'];
      print('Data fetched sucessfully');
      setState(() {});
    }

    if (path[0] == '' && path[1] == '') {
      print('calling get user future delayed');

      getUser();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BTech Shayak'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider).signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: const Menu(),
      body: path[0] == ''
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<dynamic>(
              stream: ref.read(firestoreProvider).getSubjects(
                  path: 'subjects', year: path[0], branch: path[1]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final subjects = snapshot.data.docs;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount:
                          MediaQuery.of(context).size.width < 600 ? 2 : 4,
                      childAspectRatio: 1.3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(
                        subjects.length,
                        (index) {
                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: ListTile(
                                title: Text(
                                  subjects[index]['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  print('subject id: ${subjects[index].id}');
                                  context.pushNamed(
                                    'topics',
                                    queryParameters: {
                                      'id': subjects[index].id,
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
