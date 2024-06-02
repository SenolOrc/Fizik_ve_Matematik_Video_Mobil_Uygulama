import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/question_model.dart';

final isExamAddedProvider =
    StateNotifierProvider<AddExamNotifier, bool>((_) => AddExamNotifier(false));

class AddExamNotifier extends StateNotifier<bool> {
  AddExamNotifier(bool isAdded) : super(false);

  void changeState() {
    state = !state;
  }

  void setState(bool val) {
    state = val;
  }
}

final examListProvider =
    StateNotifierProvider<ExamListNotifier, List<QuestionModel>>(
        (_) => ExamListNotifier());

class ExamListNotifier extends StateNotifier<List<QuestionModel>> {
  ExamListNotifier() : super([]);

  void saveList(List<QuestionModel> list) {
    state = list;
  }
}

final currentLessonNotifier =
    StateNotifierProvider<CurrentLessonNotifier, LessonModel>(
        (_) => CurrentLessonNotifier());

class CurrentLessonNotifier extends StateNotifier<LessonModel> {
  CurrentLessonNotifier() : super(LessonModel());

  void setLesson(LessonModel lesson) {
    state = lesson;
  }
}
