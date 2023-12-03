import 'package:btechshayak/screens/menu.dart';
import 'package:btechshayak/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Practice extends ConsumerStatefulWidget {
  const Practice({super.key});

  @override
  ConsumerState<Practice> createState() => _PracticeState();
}

class _PracticeState extends ConsumerState<Practice> {
  int currentQuestionIndex = 0;
  List<dynamic> mcqList = []; // Replace with your actual data from Firebase

  @override
  Widget build(BuildContext context) {
    String userAnswer = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      drawer: const Menu(),
      body: Column(
        children: [
          const SizedBox(height: 20),
          StreamBuilder<dynamic>(
            stream: ref.read(firestoreProvider).streamCollection(path: 'mcq'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final mcqList = snapshot.requireData.docs;
              print('mcq data: ${mcqList}');

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      mcqList[currentQuestionIndex]['question'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: List.generate(
                        mcqList[currentQuestionIndex]['options'].length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: userAnswer != ''
                                ? userAnswer ==
                                        mcqList[currentQuestionIndex]['options']
                                            [index]
                                    ? Colors.green
                                    : Colors.red
                                : Colors.transparent,
                            child: ListTile(
                              title: Center(
                                child: Text(mcqList[currentQuestionIndex]
                                    ['options'][index]),
                              ),
                              onTap: () {
                                print('mcq list : ${mcqList.length}');

                                setState(() {
                                  userAnswer = mcqList[currentQuestionIndex]
                                      ['options'][index];
                                  print('userAnswer: $userAnswer');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () => nextQuestion(mcqList.length),
                        child: const Text('Next Question'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void nextQuestion(int length) {
    setState(() {
      print('length: ${currentQuestionIndex < mcqList.length - 1}');
      print('current length: $currentQuestionIndex');
      print('mcq length: ${mcqList.length - 1}');
      if (currentQuestionIndex < length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex = 0;
      }
    });
  }
}
