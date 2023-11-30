import 'package:btechshayak/service/titleCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSubject extends ConsumerStatefulWidget {
  const AddSubject({super.key});

  @override
  ConsumerState<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends ConsumerState<AddSubject> {
  Map<String, dynamic> model = {};
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> urlController = [TextEditingController(text: '')];
  List urls = [''];
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
                    setState(() {
                      year = value.toString();
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      model['year'] = value.toString();
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
                  onSaved: (value) {
                    setState(() {
                      model['branch'] = value.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  ],
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
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Url ${index + 1}',
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
                              labelText: 'Subject Url ',
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
                  child: const Text('Add Url'),
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
              model['urls'] = urls;
              print('model: $model');
              // ref.read(firestoreProvider).addData(path: 'subjects', model: {});
            }
          },
          child: const Text('Add Subject Data'),
        ),
      ),
    );
  }
}
