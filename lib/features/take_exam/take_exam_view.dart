import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/features/result_exam/result_exam_view.dart';
import 'package:quiz_app/utils/models/question_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final selectedAnswersProvider =
    StateNotifierProvider<SelectedAnswersNotifier, List<String>>(
        (ref) => SelectedAnswersNotifier());

class SelectedAnswersNotifier extends StateNotifier<List<String>> {
  SelectedAnswersNotifier() : super(['', '', '', '', '', '', '', '', '', '']);

  void setEmpty() {
    state = ['', '', '', '', '', '', '', '', '', ''];
  }
}

class TakeExam extends ConsumerStatefulWidget {
  final List<QuestionModel> questions;
  final String subtitle;

  const TakeExam({required this.subtitle, Key? key, required this.questions})
      : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<TakeExam> {
  int _currentIndex = 0;
  int selectedButtonIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selectedAnswers = ref.watch(selectedAnswersProvider.notifier).state;
    final question = widget.questions[_currentIndex];
    final optionLetters = ['A', 'B', 'C', 'D', 'E'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sınav'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Soru ${_currentIndex + 1}:',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Image.network(
                    question.question ?? '',
                    height: 30.h,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Soru Bulunamadı')),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SizedBox(
                    width: 100.w,
                    child: ListView.builder(
                      itemCount: question.answers!.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isSelected = selectedButtonIndex == index;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final result = indexToLetter(index);
                                  ref
                                      .read(selectedAnswersProvider.notifier)
                                      .state[_currentIndex] = result;

                                  setState(() {
                                    selectedButtonIndex = index;
                                  });
                                  inspect(ref
                                      .read(selectedAnswersProvider.notifier)
                                      .state);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 20, 20, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  backgroundColor: isSelected
                                      ? const Color.fromARGB(255, 120, 120, 120)
                                      : null,
                                ),
                                child: Text(
                                  question.answers![index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontSize: 18,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ),
                              if (isSelected)
                                const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.check),
                                    )),
                              if (!isSelected)
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        optionLetters[index],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _currentIndex <= 0
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_currentIndex != 0) {
                                    _currentIndex--;
                                    final letterToIndexResult = letterToIndex(
                                        selectedAnswers[_currentIndex]);

                                    selectedButtonIndex = letterToIndexResult;
                                  }
                                });
                              },
                              child: const Text('Önceki')),
                        ),
                ),
                Expanded(
                  child: _currentIndex == widget.questions.length - 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                final List<String> answersList = widget
                                    .questions
                                    .map((question) => question.correctAnswer!)
                                    .toList();
                                final examScore = findAndCountMatchingElements(
                                    selectedAnswers, answersList);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultExamView(
                                        subtitle: widget.subtitle,
                                        selectedAnswers: selectedAnswers,
                                        passGrade:
                                            widget.questions[0].passGrade ?? 50,
                                        score: examScore,
                                      ),
                                    ));

                                inspect(selectedAnswers);
                              },
                              child: const Text('Sınavı Bitir')),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: _currentIndex < widget.questions.length - 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                selectedButtonIndex = -1;

                                setState(() {
                                  if (_currentIndex < widget.questions.length) {
                                    _currentIndex++;
                                    final letterToIndexResult = letterToIndex(
                                        selectedAnswers[_currentIndex]);

                                    selectedButtonIndex = letterToIndexResult;
                                  }
                                  print('cur: $_currentIndex');
                                  print('leng: ${widget.questions.length}');
                                });
                              },
                              child: const Text('Sonraki')),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int findAndCountMatchingElements(List<String> list1, List<String> list2) {
    int minLength = list1.length < list2.length ? list1.length : list2.length;
    int counter = 0;
    for (int i = 0; i < minLength; i++) {
      if (list1[i] == list2[i]) {
        counter += 10;
      }
      print('list1 index: $i : ${list1[i]}');
      print('list2 index: $i : ${list2[i]}');
      print(counter);
    }
    return counter;
  }

  List<Widget> _buildAnswerOptions(BuildContext context, QuestionModel question,
      Function onChanged, int currentIndex) {
    final selectedAnswers = ref.read(selectedAnswersProvider.notifier).state;
    int? selected;
    int? selectedIndex = 0;
    return question.answers!.map((answer) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ElevatedButton(
          onPressed: () {
            final indexOfAnswer = question.answers!.indexOf(answer);
            final result = indexToLetter(indexOfAnswer);
            selected = question.answers!.indexOf(answer);
            selectedIndex = question.answers!.indexOf(answer);
            ref.read(selectedAnswersProvider.notifier).state[_currentIndex] =
                result;

            inspect(ref.read(selectedAnswersProvider.notifier).state);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedIndex == selected ? Colors.blue : null,
          ),
          child: Text(answer),
        ),
      );
    }).toList();
  }

  String indexToLetter(int index) {
    return switch (index) {
      0 => 'A',
      1 => 'B',
      2 => 'C',
      3 => 'D',
      4 => 'E',
      int() => 'FALSE'
    };
  }

  int letterToIndex(String value) {
    return switch (value) {
      'A' => 0,
      'B' => 1,
      'C' => 2,
      'D' => 3,
      'E' => 4,
      String() => -1,
    };
  }
}
