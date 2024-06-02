import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';

class MockFirestoreService extends Mock {
  Future<List<ExamResultModel>> getAllResults() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('examResults').get();
    final response = querySnapshot.docs
        .map((doc) => ExamResultModel.fromJson(doc.data()))
        .toList();

    return response;
  }
}

void main() {
  group('Firestore Service Tests', () {
    test('Get all exam results', () async {
      // Arrange
      final mockFirestoreService = MockFirestoreService();
      final mockData = {
        'score': 80,
        'userId': 'user123',
        // Diğer gerekli alanlar buraya eklenebilir
      };
      when(mockFirestoreService.getAllResults())
          .thenAnswer((_) async => [ExamResultModel.fromJson(mockData)]);

      // Act
      final results = await mockFirestoreService.getAllResults();

      // Assert
      inspect(results);

      // Gelen veriyi inspect etmek için print() kullanılabilir
    });
  });
}
