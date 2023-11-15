import 'package:btechshayak/router/app_checker.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      print('get User running');
      final userData =
          await ref.read(firestoreProvider).getDocument(path: 'users/$uid');
      final user = userData.data();
      ref.read(userDataProvider.notifier).state[0] = user['year'];
      ref.read(userDataProvider.notifier).state[1] = user['branch'];
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
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'BTech Shayak',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                context.go('/');
              },
            ),
            ListTile(
              title: const Text('Add Subject'),
              onTap: () {
                context.go('/addsubject');
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                context.go('about');
              },
            ),
          ],
        ),
      ),
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
                                  context.pushNamed('subjectdetails',
                                      extra: subjects[index].data()
                                          as Map<String, dynamic>);
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
