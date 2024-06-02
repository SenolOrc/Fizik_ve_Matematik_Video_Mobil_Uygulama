import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/features/add_lessons/add_exam/add_exam_view.dart';
import 'package:quiz_app/features/add_lessons/add_lessons_view.dart';
import 'package:quiz_app/features/authentication/authentication_view.dart';
import 'package:quiz_app/features/home/view/home_view.dart';
import 'package:quiz_app/features/home_tutor/home_tutor_view.dart';
import 'package:quiz_app/features/lesson/lesson_view.dart';
import 'package:quiz_app/features/register/register_view.dart';
import 'package:quiz_app/features/result_exam/result_exam_view.dart';
import 'package:quiz_app/features/take_lesson/take_lesson_view.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/utils/models/exam_model.dart';
import 'package:quiz_app/utils/models/question_model.dart';
import 'package:quiz_app/utils/scheme/quiz_theme.dart';
import 'package:quiz_app/utils/scheme/theme.dart';
import 'package:quiz_app/utils/scheme/util.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  // await auth.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Ubuntu", "Ubuntu");

    MaterialTheme theme = MaterialTheme(textTheme);
    return ResponsiveSizer(
      builder: (BuildContext, Orientation, ScreenType) {
        return MaterialApp(
            theme: theme.light(),
            debugShowCheckedModeBanner: false,
            home: const AuthenticationView());
      },
    );
  }
}
