// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:quiz_app/provs/exam_provider.dart';
import 'package:quiz_app/utils/models/question_model.dart';

final imageFileProvider = StateProvider<XFile?>((ref) => null);

class AddExamViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  final TextEditingController optionEController = TextEditingController();
  final TextEditingController passGradeController =
      TextEditingController(text: '0');

  List<QuestionModel> questionModels =
      List<QuestionModel>.filled(10, QuestionModel());

  String? selectedOption;
  int currentQuestion = 0;
  final int amountOfQuestion = 9;
  bool isAllCheck = false;

  final ImagePicker _imagePicker = ImagePicker();
  final Reference _storageReference = FirebaseStorage.instance.ref();
  XFile? imageFile;
  String? imagePath;
  String? downloadURL;

  Future<void> uploadImage(String path) async {
    if (imageFile == null) {
      // Resim seçilmemişse bir hata göster

      return;
    }

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Resmi seçildikten sonra Storage'a yükle
      TaskSnapshot snapshot = await _storageReference
          .child('questions')
          .child(uniqueFileName)
          .putFile(File(path));

      // Yükleme başarılı olduysa, Storage'daki URL'yi al
      downloadURL = await snapshot.ref.getDownloadURL();

      // URL'yi kullanarak istediğiniz işlemi yapabilirsiniz, örneğin veritabanına kaydedebilirsiniz
      print('Resim başarıyla yüklendi. URL: $downloadURL');
    } catch (error) {
      print('resim firestorea yuklenemedi');
      rethrow;
    }
  }

  Future<void> getImage(ImageSource source) async {
    XFile? pickedImage = await _imagePicker.pickImage(source: source);
    imageFile = pickedImage;
    imagePath = pickedImage?.path;
    notifyListeners();
  }

  Future<void> onPressedSave(WidgetRef ref, BuildContext context) async {
    if (formKey.currentState!.validate() &&
        selectedOption != null &&
        imagePath != null) {
      // add model to list
      questionModels[currentQuestion] = QuestionModel(
        passGrade: int.parse(passGradeController.text),
        question: imagePath,
        answers: [
          optionAController.text,
          optionBController.text,
          optionCController.text,
          optionDController.text,
          optionEController.text
        ],
        correctAnswer: selectedOption!,
      );
      inspect(questionModels);
      for (var e in questionModels) {
        await uploadImage(e.question!);
        e.question = downloadURL;
        print('---');
      }
      inspect(questionModels);

      ref.read(isExamAddedProvider.notifier).setState(true);
      ref.read(examListProvider.notifier).saveList(questionModels);
      notifyListeners();
      Navigator.pop(context);
    }
    // inspect(ref.read(examListProvider));
  }

  void onPressedNextQuestion() {
    if (formKey.currentState!.validate() &&
        selectedOption != null &&
        imagePath != null) {
      // add model to list
      questionModels[currentQuestion] = QuestionModel(
        passGrade: int.parse(passGradeController.text),
        question: imagePath,
        answers: [
          optionAController.text,
          optionBController.text,
          optionCController.text,
          optionDController.text,
          optionEController.text
        ],
        correctAnswer: selectedOption!,
      );
      inspect(questionModels);
      currentQuestion++;

      if (questionModels[currentQuestion].question == null) {
        imagePath = null;
        optionAController.text = '';
        optionBController.text = '';
        optionCController.text = '';
        optionDController.text = '';
        optionEController.text = '';
        passGradeController.text = '0';
        selectedOption = null;
      } else {
        imagePath = questionModels[currentQuestion].question!;
        passGradeController.text =
            (questionModels[currentQuestion].passGrade!).toString();
        optionAController.text = questionModels[currentQuestion].answers![0];
        optionBController.text = questionModels[currentQuestion].answers![1];
        optionCController.text = questionModels[currentQuestion].answers![2];
        optionDController.text = questionModels[currentQuestion].answers![3];
        optionEController.text = questionModels[currentQuestion].answers![4];
        selectedOption = questionModels[currentQuestion].correctAnswer;
      }
      notifyListeners();
    }
  }

  void onPressedPreviousQuestion() {
    if (passGradeController.text.isEmpty) {
      passGradeController.text = '0';
    }
    questionModels[currentQuestion] = QuestionModel(
      question: imagePath ?? '',
      passGrade: int.parse(passGradeController.text),
      answers: [
        optionAController.text,
        optionBController.text,
        optionCController.text,
        optionDController.text,
        optionEController.text
      ],
      correctAnswer: selectedOption,
    );

    currentQuestion--;

    imagePath = questionModels[currentQuestion].question!;
    passGradeController.text =
        (questionModels[currentQuestion].passGrade!).toString();
    optionAController.text = questionModels[currentQuestion].answers![0];
    optionBController.text = questionModels[currentQuestion].answers![1];
    optionCController.text = questionModels[currentQuestion].answers![2];
    optionDController.text = questionModels[currentQuestion].answers![3];
    optionEController.text = questionModels[currentQuestion].answers![4];
    selectedOption = questionModels[currentQuestion].correctAnswer;
    notifyListeners();
  }
}
