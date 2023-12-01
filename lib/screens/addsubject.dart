// ignore_for_file: avoid_print

import 'package:btechshayak/service/firestore_service.dart';
import 'package:btechshayak/service/titleCase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddSubject extends ConsumerStatefulWidget {
  const AddSubject({super.key});

  @override
  ConsumerState<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends ConsumerState<AddSubject> {
  final modelProvider = StateProvider<Map<String, dynamic>>((ref) {
    return {};
  });
  List subjects = [];
  Map<String, dynamic> subjectsId = {};

  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> urlController = [TextEditingController(text: '')];
  List urls = [''];
  String year = '';
  String branch = '';
  List yearList = [
    'first',
    //  'second', 'third', 'fourth'
  ];
  List branchList = [
    'cse',
    'ece',
    // 'eee',
    // 'mech',
    // 'civil',
    // 'it',
    // 'chemical',
    // 'biotech',
    // 'agri',
    // 'other'
  ];

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(modelProvider);

    fetchData() async {
      print('fetch data called');
      final data = await FirebaseFirestore.instance
          .collection('subjects')
          .where('year', isEqualTo: model['year'])
          .where('branch', isEqualTo: model['branch'])
          .get();
      for (final doc in data.docs) {
        final data = doc.data();
        print('data: ${doc.id}');
        final name = data['name'];
        subjectsId[name] = doc.id;
        subjects.add(name);
        subjects = subjects.toSet().toList();
      }
      setState(() {});
    }

    print('subjects: $subjects');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
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
                    ref
                        .read(modelProvider.notifier)
                        .state
                        .addAll({'year': value.toString()});
                  },
                  onSaved: (value) {
                    ref
                        .read(modelProvider.notifier)
                        .state
                        .addAll({'year': value.toString()});
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
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
                          ref
                              .read(modelProvider.notifier)
                              .state
                              .addAll({'branch': value.toString()});
                          setState(() {});
                        },
                        onSaved: (value) {
                          ref
                              .read(modelProvider.notifier)
                              .state
                              .addAll({'branch': value.toString()});
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: FilledButton(
                        // rectangle border radius
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          if (model['year'] != null &&
                              model['branch'] != null) {
                            print('running fetch data');
                            fetchData();
                          }
                        },
                        child: const Text('Fetch '),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  value: model['subject'],
                  decoration: InputDecoration(
                    labelText: 'Subject Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: subjects
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(modelProvider.notifier)
                        .state
                        .addAll({'subject': value.toString()});
                    setState(() {
                      print(model['subject']);
                    });
                  },
                  onSaved: (value) {
                    ref
                        .read(modelProvider.notifier)
                        .state
                        .addAll({'subject': value.toString()});
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                // TextFormField(
                //   inputFormatters: [
                //     FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                //   ],
                //   decoration: const InputDecoration(
                //     labelText: 'Subject Name',
                //     border: OutlineInputBorder(),
                //   ),
                //   onChanged: (value) {},
                //   onSaved: (newValue) {},
                // ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(urlController.length, (index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Topic ${index + 1}',
                              ),
                              index != 0
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          urlController.removeAt(index);
                                          urls.removeAt(index);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    )
                                  : Container(),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextFormField(
                            // controller: urlController[index],
                            // readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Topic Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                urls[index] = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ]);
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      urlController.add(TextEditingController());
                      urls.add('');
                    });
                  },
                  child: const Text('Add Topic'),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          onPressed: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              // print('model: $model');
              print('urls $urls');
              print('subjectId: ${subjectsId[model['subject']]}');
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                              'Are you sure you want to add these Topics? \n Please Confirm Once'),
                          const SizedBox(
                            height: 20,
                          ),
                          urls.isNotEmpty
                              ? Text(urls.map((url) => '- $url').join('\n'),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                              : Container(),
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              for (final url in urls) {
                                ref.read(firestoreProvider).addData(
                                    path:
                                        'subjects/${subjectsId[model['subject']]}/topics',
                                    model: {'name': url});
                              }
                              print(
                                  'adding data in subjects/${subjectsId[model['subject']]}/topics');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Subject Added'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Confirm')),
                      ],
                    );
                  });
            }
          },
          child: const Text('Add Subject Data'),
        ),
      ),
    );
  }
}
