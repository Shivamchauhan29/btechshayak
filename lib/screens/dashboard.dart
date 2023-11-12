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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authProvider).signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<dynamic>(
        stream: ref
            .read(firestoreProvider)
            .getSubjects(path: 'subjects', year: path[0], branch: path[1]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final subjects = snapshot.data.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
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
