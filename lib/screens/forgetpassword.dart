import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class ForgetPassword extends ConsumerStatefulWidget {
  const ForgetPassword({super.key});

  @override
  ConsumerState<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends ConsumerState<ForgetPassword> {
  bool visibility = true;
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onVerticalDragDown: (_) {
        FocusScope.of(context).unfocus();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
              // title: const Text('Forget Password'),
              ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ClipPath(
                  child: Image(
                    image: AssetImage(
                      'assets/Forget.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0.0),
                  child: Text(
                    'Forget password?',
                    style: Theme.of(context).textTheme.headlineSmall!.merge(
                        const TextStyle(
                            color: Color(0xff445FD2),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        // label: const Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintText: 'Email'),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: const Size(348, 48),
                ),
                onPressed: () {
                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'We have sent you email to recover password, please check email'),
                          ),
                        ),
                      )
                      .onError((error, stackTrace) =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('got a error')),
                          ));
                },
                child: Text(
                  'Submit',
                  style: Theme.of(context).textTheme.bodyLarge!.merge(
                      const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
