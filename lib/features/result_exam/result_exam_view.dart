import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:quiz_app/features/home/view/home_view.dart';
import 'package:quiz_app/features/home_tutor/home_tutor_view.dart';
import 'package:quiz_app/features/take_exam/take_exam_view.dart';
import 'package:quiz_app/services/firestore_service.dart';
import 'package:quiz_app/utils/models/exam_result_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ResultExamView extends ConsumerStatefulWidget {
  final int score;
  final int passGrade;
  final String subtitle;
  final List<String> selectedAnswers;

  const ResultExamView({
    required this.subtitle,
    required this.score,
    required this.passGrade,
    super.key,
    required this.selectedAnswers,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResultExamViewState();
}

class _ResultExamViewState extends ConsumerState<ResultExamView> {
  @override
  Widget build(BuildContext context) {
    final bool isPassed = widget.score > widget.passGrade;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            isPassed ? 'Tebrikler Geçtiniz!' : 'Maalesef Kaldınız',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Gap(3.h),
          Text(
            'Notunuz: ${widget.score}/100',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Gap(3.h),
          Center(
            child: Icon(
              isPassed ? Icons.check_circle : Icons.thumb_down_alt,
              color: isPassed ? Colors.green : Colors.red,
              size: 50.w,
            ),
          ),
          Gap(10.h),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                ref.read(selectedAnswersProvider.notifier).setEmpty();
                FirestoneService.instance.saveExamResult(
                    ref,
                    ExamResultModel(
                        subtitle: widget.subtitle,
                        score: widget.score,
                        isPassed: isPassed,
                        answers: widget.selectedAnswers));
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeView(),
                    ));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue[50]),
                  padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h))),
              child: Text(
                'Anasayfa',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          Gap(3.h),
        ],
      ),
    );
  }
}
