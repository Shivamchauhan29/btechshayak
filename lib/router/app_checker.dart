import 'package:btechshayak/screens/dashboard.dart';
import 'package:btechshayak/screens/signup.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'not_found_screen.dart';

final userDataProvider = StateProvider<List>((ref) => ['', '']);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authStateChange;
});

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  now the build method takes a new paramaeter ScopeReader.
    //  this object will be used to access the provider.

    //  now the following variable contains an asyncValue so now we can use .when method
    //  to imply the condition
    final authState = ref.watch(authStateProvider);
    final uid = ref.read(authProvider).currentUser?.uid;

    getUser() async {
      final userData =
          await ref.read(firestoreProvider).getDocument(path: 'users/$uid');
      final user = userData.data();
      Future.delayed(const Duration(milliseconds: 20), () {
        ref.read(userDataProvider.notifier).state[0] = user['year'];
        ref.read(userDataProvider.notifier).state[1] = user['branch'];
      });
    }

    return authState.when(
      data: (data) {
        if (data != null) {
          // print('uid: $uid');
          Future.delayed(const Duration(milliseconds: 20), () {
            getUser();
            return const DashBoard();
          });
        }
        return const SignUp();
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, trace) => const NotFoundScreen(),
    );
  }
}
