import 'package:btechshayak/screens/menu.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Feedback extends ConsumerWidget {
  const Feedback({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> model = {};

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      drawer: const Menu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Feedback',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your feedback here',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide your feedback';
                  }
                  return null;
                },
                onSaved: (value) {
                  model['feedback'] = value;
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  formKey.currentState!.save();
                  if (formKey.currentState!.validate()) {
                    // print('form validated');
                    ref.read(firestoreProvider).addData(
                        path:
                            'users/${ref.read(authProvider).currentUser!.uid}/feedback',
                        model: model);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content:
                            Text('Your Feedback is Valuable! Thank You! ❤️'),
                      ),
                    );
                    formKey.currentState!.reset();
                  }
                },
                child: const Text('Submit Your Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
