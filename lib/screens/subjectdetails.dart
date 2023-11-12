import 'package:flutter/material.dart';

class SubjectDetails extends StatefulWidget {
  final dynamic subjectData;
  const SubjectDetails({this.subjectData, super.key});

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.subjectData['urls']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Learning Here'),
      ),
      body: Center(
        child: Text('widget.subjectData'),
      ),
    );
  }
}
