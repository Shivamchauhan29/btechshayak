import 'package:btechshayak/service/auth_service.dart';
import 'package:btechshayak/service/titleCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final dateFilterProvider = StateProvider<DateTime>((ref) => DateTime.now());
final TextEditingController _emailController = TextEditingController(text: "");
final _formKey = GlobalKey<FormState>();

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  bool showOtp = false;
  String password = '';
  String confirmPass = '';
  String fullName = '';
  String age = '';
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
  // final dateFilter = ref.watch(dateFilterProvider);
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider);

    // To calculate the age
    // String calculateAge(String dob) {
    //   final dobDate = DateTime.parse(dob);
    //   final currentDate = DateTime.now();

    //   final age = currentDate.year -
    //       dobDate.year -
    //       (currentDate.isBefore(
    //               DateTime(currentDate.year, dobDate.month, dobDate.day))
    //           ? 1
    //           : 0);
    //   return age.toString();
    // }

    // selectDate(BuildContext context) async {
    //   final DateTime? picked = await showDatePicker(
    //       context: context,
    //       initialDate: dateFilter,
    //       firstDate: DateTime(1980, 8),
    //       lastDate: DateTime.now());
    //   if (picked != null && picked != dateFilter) {
    //     setState(() {
    //       // String picked = Dateformat
    //       _dateController.text = picked.toString().split(' ')[0];
    //       age = calculateAge(_dateController.text.toString());
    //       // ignore: avoid_print
    //       print(age);
    //     });
    //     ref.read(dateFilterProvider.notifier).state = picked;
    //   }
    // }

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const SizedBox(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const SizedBox(
                height: 120.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  child: Image(
                    image: AssetImage('assets/signup.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          } else if (!value.contains('@') &&
                              !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          // validate if the email is filled or not
                          // if filled then send otp to the email address

                          setState(() {
                            if (!_emailController.text.contains('@') &&
                                !_emailController.text.contains('.')) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid Email'),
                                ),
                              );
                            } else if (_emailController.text.isNotEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('OTP'),
                                        content:
                                            const Text('OTP Sent Successfully'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                showOtp = true;
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('OK'))
                                        ],
                                      ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Please enter your email address'),
                                ),
                              );
                            }
                          });
                        },
                        child: const Text('Send OTP')),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              (showOtp == true)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'OTP',
                                hintText: 'Enter your OTP',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType
                                  .phone, // You can use TextInputType.number for a numeric keyboard
                            ),
                          ),
                          TextButton(
                              onPressed: () {}, child: const Text('Verify')),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10.0,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: _dateController,
              //     decoration: const InputDecoration(
              //       labelText: 'Date of Birth',
              //       border: OutlineInputBorder(),
              //       prefixIcon: Icon(Icons.calendar_today),
              //     ),
              //     onTap: () {
              //       selectDate(context);
              //     },
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return 'Please enter your date of birth';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              // const SizedBox(
              //   height: 10.0,
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                    setState(() {
                      branch = value.toString();
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Create Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value.toString().trim();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please create your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[ ]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmPass = value.toString().trim();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Confirm your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextButton(
                onPressed: () {
                  context.push('/login');
                },
                child: const Text('Already Have an Account'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 48.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (password == confirmPass) {
                          auth.signUpWithEmailAndPassword(_emailController.text,
                              password, fullName, year, branch, context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password does not match'),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Confirm',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
