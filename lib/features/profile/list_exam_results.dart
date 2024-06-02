import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';

class ExamResultsPage extends StatefulWidget {
  const ExamResultsPage({super.key});

  @override
  _ExamResultsPageState createState() => _ExamResultsPageState();
}

class _ExamResultsPageState extends State<ExamResultsPage> {
  late Future<List<ExamResultModel>> mathResults;
  late Future<List<ExamResultModel>> physicsResults;

  @override
  void initState() {
    super.initState();
    mathResults = _getExamResults('Matematik');
    physicsResults = _getExamResults('Fizik');
  }

  Future<List<ExamResultModel>> _getExamResults(String lessonName) async {
    final userUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final querySnapshot = await FirebaseFirestore.instance
        .collection('examResults')
        .doc(userUid)
        .collection(lessonName)
        .get();
    return querySnapshot.docs
        .map((doc) => ExamResultModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matematik Sınavları:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<ExamResultModel>>(
                future: mathResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Bir hata oluştu: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final result = snapshot.data![index];
                        return ListTile(
                          title:
                              Text('Sınav ${index + 1} : ${result.subtitle}'),
                          subtitle: Text(
                            'Not: ${result.score}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  result.isPassed ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: Icon(
                            result.isPassed ? Icons.check : Icons.close,
                            color: result.isPassed ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fizik Sınavları:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<ExamResultModel>>(
                future: physicsResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Bir hata oluştu: ${snapshot.error}'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final result = snapshot.data![index];
                        return ListTile(
                          title:
                              Text('Sınav ${index + 1} : ${result.subtitle}'),
                          subtitle: Text(
                            'Not: ${result.score}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  result.isPassed ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: Icon(
                            result.isPassed ? Icons.check : Icons.close,
                            color: result.isPassed ? Colors.green : Colors.red,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
