import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:quiz_app/features/lesson/lesson_viewmodel.dart';
import 'package:quiz_app/features/take_lesson/take_lesson_view.dart';
import 'package:quiz_app/provs/exam_provider.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/constants/quiz_api_keys.dart';
import 'package:quiz_app/utils/enums/lesson_names.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';
import 'package:quiz_app/utils/models/question_model.dart';
import 'package:quiz_app/utils/widgets/custom_listile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LessonView extends ConsumerStatefulWidget {
  final LessonNames pickedLesson;
  const LessonView(this.pickedLesson, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonViewState();
}

class _LessonViewState extends ConsumerState<LessonView> {
  final LessonViewModel _viewmodel = LessonViewModel();

  @override
  void initState() {
    super.initState();
    // canTakeLesson(widget.pickedLesson);
    _viewmodel.lessonsFuture = _viewmodel.getLessons(widget.pickedLesson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konu Başlıkları'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FutureBuilder<List<LessonModel>>(
          future: _viewmodel.lessonsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final lessons = snapshot.data!;
              return lessons.isEmpty
                  ? Center(
                      child: Text(
                      'Görüntülenecek ders kaydı bulunamadı.',
                      style: context.general.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      itemCount: lessons.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: CustomListTile(
                            canTakeLessonIndex: _viewmodel.canTakeLessonIndex,
                            index: index,
                            onTap: () {
                              _viewmodel.tileOnPressed(
                                  ref, context, index, lessons);
                            },
                            title: lessons[index].subtitle,
                          ),
                        );
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
