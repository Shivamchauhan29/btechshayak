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
        title: Text('MCQ Page'),
      ),
      drawer: const Menu(),
      body: Column(
        children: [
          SizedBox(height: 20),
          StreamBuilder<dynamic>(
            stream: ref.read(firestoreProvider).streamCollection(path: 'mcq'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final mcqList = snapshot.requireData.docs;
              print('mcq data: ${mcqList}');

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      mcqList[currentQuestionIndex]['question'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () => nextQuestion(),
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

  void nextQuestion() {
    setState(() {
      print('mcq list : ${mcqList.length}');
      print('length: ${currentQuestionIndex < mcqList.length - 1}');
      print('current length: $currentQuestionIndex');
      print('mcq length: ${mcqList.length - 1}');
      if (currentQuestionIndex < mcqList.length - 1) {
        currentQuestionIndex++;
      } else {
        currentQuestionIndex++;
      }
    });
  }
}
