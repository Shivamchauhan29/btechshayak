import 'package:btechshayak/service/titleCase.dart';
import 'package:flutter/material.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  List<TextEditingController> urlController = [];
  String year = '';
  String branch = '';
  List yearList = ['first', 'second', 'third', 'fourth'];
  List branchList = [
    'cse',
    'ece',
    'eee',
    'mech',
    'civil',
    'it',
    'chemical',
    'biotech',
    'agri',
    'other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            child: ListView(
          children: [
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: yearList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(titleCase(e)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  year = value.toString();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Branch',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: branchList
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(titleCase(e)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  branch = value.toString();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Subject Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
              onSaved: (newValue) {},
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: List.generate(urlController.length, (index) {
                return Column(children: [
                  TextFormField(
                    // controller: urlController[index],
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Freight',
                    ),
                  ),
                ]);
              }),
            ),
          ],
        )),
      ),
    );
  }
}
