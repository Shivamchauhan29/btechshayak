import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SubjectDetails extends ConsumerStatefulWidget {
  final dynamic subjectData;
  const SubjectDetails({this.subjectData, Key? key}) : super(key: key);

  @override
  ConsumerState<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends ConsumerState<SubjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Learning Here'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<dynamic>(
            future: ref
                .read(firestoreProvider)
                .getDocument(path: 'subjects/u3cjGUddXsSe8MIwi967'),
            builder: (context, snapshot) {
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
              final document = snapshot.requireData.data();
              final urls = document['urls'];
              print('document: $urls');
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).size.width < 600 ? 2 : 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: urls.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed('videoplayer', queryParameters: {
                        'url': urls[index],
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            urls[index],
                            style: const TextStyle(fontSize: 10.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
