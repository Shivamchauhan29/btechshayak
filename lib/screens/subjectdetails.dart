import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubjectDetails extends StatefulWidget {
  final dynamic subjectData;
  const SubjectDetails({this.subjectData, Key? key}) : super(key: key);

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  @override
  Widget build(BuildContext context) {
    List urls = widget.subjectData['urls'];
    // print('urls: $urls');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Learning Here'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
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
              child: Center(
                child: Text(
                  urls[index],
                  style: const TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
