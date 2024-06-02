import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:quiz_app/features/take_exam/take_exam_view.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TakeLessonView extends ConsumerStatefulWidget {
  final LessonModel lessonModel;
  const TakeLessonView(this.lessonModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TakeLessonViewState();
}

class _TakeLessonViewState extends ConsumerState<TakeLessonView> {
  late final YoutubePlayerController _controller;
  @override
  void initState() {
    String videoId =
        YoutubePlayer.convertUrlToId(widget.lessonModel.videoURL!) ??
            'RYhgMEN-Jvg';

    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonModel.lessonName!),
      ),
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {},
        ),
        builder: (context, player) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _lessonContent(player),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.lessonModel.questionModel != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TakeExam(
                                  subtitle:
                                      widget.lessonModel.subtitle ?? 'Exam',
                                  questions: widget.lessonModel.questionModel!),
                            ));
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sınava Geç',
                          style: TextStyle(fontSize: 20),
                        ),
                        Gap(4.w),
                        const Icon(Icons.arrow_right_alt)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column _lessonContent(Widget player) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.lessonModel.subtitle ?? '',
          style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2.h),
        player,
        const SizedBox(height: 16),
        const Text(
          'Açıklama:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.lessonModel.description ?? '',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
