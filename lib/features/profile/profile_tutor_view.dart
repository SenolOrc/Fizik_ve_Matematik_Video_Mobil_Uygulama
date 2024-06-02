import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';
import 'package:quiz_app/utils/models/user_info_model.dart';

class TeacherExamResultsPage extends StatefulWidget {
  const TeacherExamResultsPage({super.key});

  @override
  _TeacherExamResultsPageState createState() => _TeacherExamResultsPageState();
}

class _TeacherExamResultsPageState extends State<TeacherExamResultsPage> {
  late List<ExamResultModel> allResults;

  @override
  void initState() {
    super.initState();
    _getAllResults();
  }

  Future<List<ExamResultModel>> _getAllResults() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('examResults').get();
    final response = querySnapshot.docs
        .map((doc) => ExamResultModel.fromJson(doc.data()))
        .toList();

    inspect(response);
    return response;
  }

  Future<String> _getUserName(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('user_info').doc(uid).get();
    final userData = snapshot.data() as Map<String, dynamic>;
    final user = UserInfoModel.fromJson(userData);
    return user.name ?? 'Bilinmeyen Kullanıcı';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tüm Sınav Sonuçları'),
      ),
      body: _getAllResults == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allResults.length,
              itemBuilder: (context, index) {
                final result = allResults[index];
                return FutureBuilder(
                  future: _getAllResults(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text('Sınav ${index + 1}'),
                        subtitle: const Text('Öğrenci: Bekleniyor...'),
                        trailing: Text('Not: ${result.score}'),
                      );
                    } else if (snapshot.hasError) {
                      return ListTile(
                        title: Text('Sınav ${index + 1}'),
                        subtitle: Text('Öğrenci: Hata: ${snapshot.error}'),
                        trailing: Text('Not: ${result.score}'),
                      );
                    } else {
                      return ListTile(
                        title: Text('Sınav ${index + 1}'),
                        subtitle: Text('Öğrenci: ${snapshot.data}'),
                        trailing: Text('Not: ${result.score}'),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
