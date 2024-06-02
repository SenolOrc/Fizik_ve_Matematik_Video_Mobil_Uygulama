import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/enums/lesson_names.dart'; // adjust the import according to your file structure

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  });

  tearDownAll(() async {
    // Optionally, clean up the database after tests
    final ref = FirebaseFirestore.instance.collection('exams');
    final snapshots = await ref.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  });

  group('FirestoneService Tests', () {
    test('Fetch exams successfully', () async {
      // Prepare test data
      final ref = FirebaseFirestore.instance
          .collection('exams')
          .doc('exam')
          .collection('lessonName');
      await ref.add({
        'lessonName': 'Math',
        'subtitle': 'Algebra',
        'videoURL': 'http://example.com/video',
        'description': 'Algebra basics',
        'questionModel': [
          {
            'question': 'What is 2+2?',
            'answers': ['3', '4', '5'],
            'correctAnswer': '4',
            'passGrade': 50
          }
        ]
      });

      // Act
      final exams =
          await FirestoneService.instance.getExams(LessonNames.Matematik);

      // Assert
      expect(exams.length, 1);
      final exam = exams.first;
      expect(exam.lessonName, 'Matematik');
      expect(exam.subtitle, 'Kesirler');
      expect(exam.videoURL, 'http://example.com/video');
      expect(exam.description, 'Algebra basics');
      expect(exam.questionModel?.length, 1);
      final question = exam.questionModel?.first;
      expect(question?.question, 'What is 2+2?');
      expect(question?.answers, ['3', '4', '5']);
      expect(question?.correctAnswer, '4');
      expect(question?.passGrade, 50);
    });
  });
}
