import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/features/take_exam/take_exam_view.dart';
import 'package:quiz_app/utils/models/question_model.dart';

class TakeExamViewModel {
  void selectAnswer(WidgetRef ref, QuestionModel question, Function onChanged,
      int currentIndex, String answer) {
    final indexOfAnswer = question.answers!.indexOf(answer);
    final result = indexToLetter(indexOfAnswer);

    ref.read(selectedAnswersProvider.notifier).state[currentIndex] = result;
    onChanged.call();

    inspect(ref.read(selectedAnswersProvider.notifier).state);
  }

  String indexToLetter(int index) {
    return switch (index) {
      0 => 'A',
      1 => 'B',
      2 => 'C',
      3 => 'D',
      int() => 'A'
    };
  }
}
