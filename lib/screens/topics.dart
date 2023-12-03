import 'package:btechshayak/screens/menu.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Topics extends ConsumerStatefulWidget {
  final String? id;
  const Topics({super.key, this.id});

  @override
  ConsumerState<Topics> createState() => _TopicsState();
}

class _TopicsState extends ConsumerState<Topics> {
  @override
  Widget build(BuildContext context) {
    // print('id: ${widget.id}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
      ),
      drawer: const Menu(),
      body: StreamBuilder<dynamic>(
          stream: ref
              .read(firestoreProvider)
              .streamCollection(path: 'subjects/${widget.id}/topics'),
          builder: (builder, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final document = snapshot.requireData.docs;
            // print('document Length: ${document.length}');
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width < 600 ? 2 : 4,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: document.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        context.push('/subjectdetails');
                      },
                      child: Card(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              document[index]['name'],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
