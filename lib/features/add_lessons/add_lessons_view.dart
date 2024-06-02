import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:quiz_app/features/add_lessons/add_exam/add_exam_view.dart';
import 'package:quiz_app/features/add_lessons/add_exam/add_exam_viewmodel.dart';
import 'package:quiz_app/features/add_lessons/add_lessons_viewmodel.dart';
import 'package:quiz_app/features/home/view/home_view.dart';
import 'package:quiz_app/features/home_tutor/home_tutor_view.dart';
import 'package:quiz_app/features/lesson/lesson_viewmodel.dart';
import 'package:quiz_app/provs/exam_provider.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/enums/custom_borders.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/question_model.dart';
import 'package:quiz_app/utils/validators/quiz_validators.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddLessonsView extends ConsumerStatefulWidget {
  const AddLessonsView({Key? key}) : super(key: key);

  @override
  _AddLessonsViewState createState() => _AddLessonsViewState();
}

class _AddLessonsViewState extends ConsumerState<AddLessonsView> {
  final AddLessonsViewModel _viewModel = AddLessonsViewModel();
  final LessonViewModel _viewmodelAddLeson = LessonViewModel();

  final _formKey = GlobalKey<FormState>();
  List<String>? currentKonuBasliklari;

  String? _selectedOption;
  String? _selectedSubtitle;
  final TextEditingController _videoURLController = TextEditingController();
  final TextEditingController _lessonDescriptionController =
      TextEditingController();
  @override
  void dispose() {
    _videoURLController.dispose();
    _lessonDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentKonuBasliklari = _viewModel.matematikKonuBasliklari;
  }

  @override
  Widget build(BuildContext context) {
    final isExamAdded = ref.watch(isExamAddedProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // We can use this for fast upload
                FirestoneService.instance
                    .uploadExam(_viewmodelAddLeson.lesson1);
              },
              icon: const Icon(Icons.add))
        ],
        title: const Text(
          'Ders Ekle',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _pickLesson(),
                  Gap(2.h),
                  _pickSubtitle(),
                  Gap(2.h),
                  _enterUrl(),
                  Gap(2.h),
                  _enterDescription(),
                  Gap(3.h),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                              height: 100.h,
                              width: 100.w,
                              child: const AddExamView());
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: isExamAdded
                        ? const Icon(Icons.check)
                        : const SizedBox.shrink(),
                    label: isExamAdded
                        ? const Text('Sınav Eklendi')
                        : const Text('Sınav Ekle'),
                  ),
                  Gap(3.h),
                  ElevatedButton.icon(
                    onPressed: isExamAdded
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              final List<QuestionModel> questionList =
                                  ref.read(examListProvider.notifier).state;

                              inspect(questionList);

                              final LessonModel examModel = LessonModel(
                                  lessonName: _selectedOption,
                                  subtitle: _selectedSubtitle,
                                  description:
                                      _lessonDescriptionController.text,
                                  videoURL: _videoURLController.text,
                                  questionModel: questionList);

                              await FirestoneService.instance
                                  .uploadExam(examModel);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        const Text("Başarılı"),
                                        Gap(3.w),
                                        const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                                    content: const Text(
                                        "Ders başarıyla kaydedildi."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeTutorView(),
                                                ));
                                          },
                                          child: const Text('Anasayfaya Dön'))
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Kaydet'),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _enterDescription() {
    return TextFormField(
      controller: _lessonDescriptionController, // Controller'ı atayın
      maxLines: 5,
      validator: QuizValidators().cannotNull,
      decoration: InputDecoration(
        labelText: 'Ders Açıklaması',
        border: OutlineInputBorder(
          borderRadius: CustomBorders.highBorderRadius.getBorderRadius(),
        ),
      ),
    );
  }

  TextFormField _enterUrl() {
    return TextFormField(
      controller: _videoURLController,
      validator: QuizValidators().cannotNull,
      decoration: InputDecoration(
        suffix: IconButton(
            onPressed: () async {
              ClipboardData? clipboardData =
                  await Clipboard.getData(Clipboard.kTextPlain);
              if (clipboardData != null) {
                _videoURLController.text = clipboardData.text ?? 'asd';
              }
            },
            icon: const Icon(Icons.paste)),
        labelText: "Ders Video URL'si ",
        border: OutlineInputBorder(
          borderRadius: CustomBorders.highBorderRadius.getBorderRadius(),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _pickLesson() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Ders Seçiniz',
        border: OutlineInputBorder(),
      ),
      value: _selectedOption,
      onChanged: (String? newValue) {
        _selectedSubtitle = null;

        setState(() {
          if (newValue != null) {
            _selectedOption = newValue;
            currentKonuBasliklari = newValue == 'Fizik'
                ? _viewModel.fizikKonuBasliklari
                : _viewModel.matematikKonuBasliklari;
          }
        });
      },
      validator: QuizValidators().cannotNull,
      items: <String>['Fizik', 'Matematik'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> _pickSubtitle() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Ders Seçiniz',
        border: OutlineInputBorder(),
      ),
      value: _selectedSubtitle,
      onChanged: (String? newValue) {
        setState(() {
          if (newValue != null) {
            _selectedSubtitle = newValue;
          }
        });
      },
      validator: QuizValidators().cannotNull,
      items: currentKonuBasliklari!.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
