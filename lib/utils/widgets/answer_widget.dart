import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:quiz_app/utils/validators/quiz_validators.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnswerWidget extends ConsumerStatefulWidget {
  final String option;
  final TextEditingController? controller;

  const AnswerWidget({
    required this.option,
    this.controller,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends ConsumerState<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.option,
            style: context.general.textTheme.headlineSmall!.copyWith(
              color: Colors.black,
            )),
        Gap(1.h),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            validator: QuizValidators().cannotNull,
            decoration: InputDecoration(
              label: Text('${widget.option} şıkkının cevabını giriniz'),
            ),
          ),
        ),
      ],
    );
  }
}
