import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/features/take_lesson/take_lesson_view.dart';
import 'package:quiz_app/provs/exam_provider.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/enums/lesson_names.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';
import 'package:quiz_app/utils/models/question_model.dart';

class LessonViewModel {
  late Future<List<LessonModel>> lessonsFuture;
  int canTakeLessonIndex = 0;
  late List<ExamResultModel>? examResults;

  Future<List<LessonModel>> getLessons(LessonNames lessonName) async {
    final response = await FirestoneService.instance.getExams(lessonName);
    await canTakeLesson(lessonName);
    return response;
  }

  Future<void> canTakeLesson(LessonNames lessonName) async {
    examResults = await FirestoneService.instance.getExamResults(lessonName);
    for (var result in examResults!) {
      if (result.isPassed) {
        canTakeLessonIndex++;
      }
    }
  }

  void tileOnPressed(WidgetRef ref, BuildContext context, int index,
      List<LessonModel> lessons) {
    ref.read(currentLessonNotifier.notifier).setLesson(lessons[index]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakeLessonView(
          lessons[index],
        ),
      ),
    );
  }

  LessonModel lesson1 = LessonModel(
    lessonName: LessonNames.Fizik.name,
    subtitle: 'Enerji',
    videoURL:
        'https://www.youtube.com/watch?v=Jja7555eRFo&list=WL&index=1&t=15s',
    description: 'Matematikte kesirlerin temel kavramlarını içeren bir ders.',
    questionModel: [
      QuestionModel(
        question: '3/4 kesrinin ondalık karşılığı nedir?',
        answers: ['0.75', '1.25', '0.5', '0.33'],
        correctAnswer: 'A',
        passGrade: 50,
      ),
      QuestionModel(
        question: '5/8 kesrinin ondalık karşılığı nedir?',
        answers: ['0.63', '0.75', '0.625', '0.5'],
        correctAnswer: 'C',
        passGrade: 1,
      ),
      QuestionModel(
        question: '2/3 kesrinin ondalık karşılığı nedir?',
        answers: ['0.5', '0.66', '0.75', '0.33'],
        correctAnswer: 'B',
        passGrade: 1,
      ),
      QuestionModel(
        question: '7/10 kesrinin ondalık karşılığı nedir?',
        answers: ['0.7', '0.75', '0.6', '0.8'],
        correctAnswer: 'A',
        passGrade: 1,
      ),
      QuestionModel(
        question: '4/5 kesrinin ondalık karşılığı nedir?',
        answers: ['0.8', '0.5', '0.6', '0.75'],
        correctAnswer: 'C',
        passGrade: 1,
      ),
      QuestionModel(
        question: '1/2 kesrinin ondalık karşılığı nedir?',
        answers: ['0.5', '1.5', '0.25', '2'],
        correctAnswer: 'A',
        passGrade: 1,
      ),
      QuestionModel(
        question: '6/7 kesrinin ondalık karşılığı nedir?',
        answers: ['0.57', '0.71', '0.86', '0.42'],
        correctAnswer: 'B',
        passGrade: 1,
      ),
      QuestionModel(
        question: '3/5 kesrinin ondalık karşılığı nedir?',
        answers: ['0.2', '0.6', '0.8', '0.4'],
        correctAnswer: 'D',
        passGrade: 1,
      ),
      QuestionModel(
        question: '8/9 kesrinin ondalık karşılığı nedir?',
        answers: ['0.88', '0.9', '0.66', '0.75'],
        correctAnswer: 'B',
        passGrade: 1,
      ),
      QuestionModel(
        question: '9/10 kesrinin ondalık karşılığı nedir?',
        answers: ['0.9', '0.1', '0.6', '0.75'],
        correctAnswer: 'A',
        passGrade: 1,
      ),
    ],
  );
}
