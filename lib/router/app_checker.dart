import 'package:btechshayak/screens/dashboard.dart';
import 'package:btechshayak/screens/signup.dart';
import 'package:btechshayak/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'not_found_screen.dart';

final userDataProvider = StateProvider<List>((ref) => ['', '', '']);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authStateChange;
});

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (data) {
        if (data != null) {
          return const DashBoard();
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
