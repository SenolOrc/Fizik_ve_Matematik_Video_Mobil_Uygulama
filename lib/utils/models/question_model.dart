import 'package:equatable/equatable.dart';

class QuestionModel {
  String? question;
  List<String>? answers;
  String? correctAnswer;
  int? passGrade;

  QuestionModel({
    this.question,
    this.answers,
    this.correctAnswer,
    this.passGrade,
  });

  QuestionModel copyWith({
    String? question,
    List<String>? answers,
    String? correctAnswer,
    int? passGrade,
  }) {
    return QuestionModel(
      question: question ?? this.question,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      passGrade: passGrade ?? this.passGrade,
    );
  }

  Map<String, dynamic> toJson(QuestionModel e) {
    return {
      'question': e.question,
      'answers': e.answers,
      'correctAnswer': e.correctAnswer,
      'passGrade': e.passGrade,
    };
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json['question'] as String?,
      answers:
          (json['answers'] as List<dynamic>?)?.map((e) => e as String).toList(),
      correctAnswer: json['correctAnswer'] as String?,
      passGrade: json['passGrade'] as int?,
    );
  }

  @override
  String toString() =>
      "QuestionModel(question: $question,answers: $answers,correctAnswer: $correctAnswer,passGrade: $passGrade)";

  @override
  int get hashCode => Object.hash(question, answers, correctAnswer, passGrade);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModel &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          answers == other.answers &&
          correctAnswer == other.correctAnswer &&
          passGrade == other.passGrade;
}
