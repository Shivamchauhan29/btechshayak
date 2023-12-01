import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:go_router/go_router.dart';
// import 'package:prefil/screens/auth/verification.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();
  final _auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // String _verificationId = "";
  bool loading = false;

  //

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final usersCollection = FirebaseFirestore.instance.collection('users');
        await usersCollection.doc(userCredential.user!.uid).update({
          'lastLogin': DateTime.now(),
        });
        // ignore: use_build_context_synchronously
        context.go('/dashboard');
      }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error Occured'),
          content: const Text('Incorrect Email and Password'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  // SignUp the user using Email and Password
  Future<void> signUpWithEmailAndPassword(
      String email,
      String password,
      String fullName,
      String? year,
      String? branch,
      BuildContext context) async {
    bool signUpSuccessful = false;

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final usersCollection = FirebaseFirestore.instance.collection('users');

        await usersCollection.doc(userCredential.user!.uid).set({
          'email': email,
          'password': password,
          'fullName': fullName,
          'year': year,
          'branch': branch,
        });
        // ignore: unused_local_variable, use_build_context_synchronously
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Account Created'),
            content: const Text('Your account has been successfully created.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
        signUpSuccessful = true;
      }
    } catch (e) {
      signUpSuccessful = false;

      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          // Handle the case when email is already in use
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error Occured'),
              content: const Text('Email address is already in use.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } else {
          // Handle other FirebaseAuthExceptions
          // ignore: use_build_context_synchronously
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Error Occured'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle other exceptions
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
    if (signUpSuccessful) {
      // ignore: use_build_context_synchronously
      context.go('/');
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      // Show a success dialog
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Password Reset'),
          content: const Text('A password reset email has been sent.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show an error dialog
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error Occurred'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut().then((value) => context.go('/login'));
  }
}

final authProvider = Provider<AuthService>((ref) => AuthService._());
