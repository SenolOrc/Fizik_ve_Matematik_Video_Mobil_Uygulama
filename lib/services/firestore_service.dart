import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/provs/exam_provider.dart';
import 'package:quiz_app/utils/enums/lesson_names.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';

final class FirestoneService {
  FirestoneService._();
  static FirestoneService get instance => FirestoneService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userUID = FirebaseAuth.instance.currentUser?.uid ?? 'Diger';
  Future<void> uploadExam(LessonModel LessonModel) async {
    await _db
        .collection('exams')
        .doc('exam')
        .collection(LessonModel.lessonName ?? '')
        .doc(LessonModel.subtitle.toString())
        .set(LessonModel.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<List<LessonModel>> getExams(LessonNames lessonName) async {
    final ref = _db.collection('exams').doc('exam').collection(lessonName.name);

    final docSnap = await ref.get();
    final LessonModelData = docSnap.docs;
    // We fetch all subtitles
    List<Map<String, dynamic>> dataList =
        LessonModelData.map((snapshot) => snapshot.data()).toList();

    // We cast subtitles as LessonModel
    List<LessonModel> examList =
        dataList.map((e) => LessonModel.fromJson(e)).toList();
    return examList;
  }

  Future<List<ExamResultModel>?> getExamResults(LessonNames lessonName) async {
    final ref =
        _db.collection('examResults').doc(userUID).collection(lessonName.name);

    final docSnap = await ref.get();
    final examResultModels = docSnap.docs;
    // We fetch all subtitles
    List<Map<String, dynamic>> dataList =
        examResultModels.map((e) => e.data()).toList();

    // // We cast subtitles as ExamResultModel
    List<ExamResultModel> examResultList =
        dataList.map((e) => ExamResultModel.fromJson(e)).toList();
    return examResultList;
  }

  Future<void> saveExamResult(
      WidgetRef ref, ExamResultModel examResultModel) async {
    final currentLesson = ref.read(currentLessonNotifier);
    await _db
        .collection('examResults')
        .doc(userUID)
        .collection(currentLesson.lessonName ?? 'Diger')
        .doc(currentLesson.subtitle ?? 'Diger')
        .set(examResultModel.toJson())
        .onError((e, _) => print("Error writing document: $e"));
  }

  Future<void> deleteExamTopic(String lessonName, String topicTitle) async {
    try {
      await FirebaseFirestore.instance
          .collection('exams')
          .doc('exam')
          .collection(lessonName)
          .doc(topicTitle)
          .delete();
      print('Konu başlığı silindi: $topicTitle');
    } catch (e) {
      print('Konu başlığı silinirken hata oluştu: $e');
      rethrow; // Hata yeniden fırlatılıyor
    }
  }
}
