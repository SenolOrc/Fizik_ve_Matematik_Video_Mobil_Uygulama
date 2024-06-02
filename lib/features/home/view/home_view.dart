import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:quiz_app/features/authentication/authentication_view.dart';
import 'package:quiz_app/features/home_tutor/home_tutor_view.dart';
import 'package:quiz_app/features/lesson/lesson_view.dart';
import 'package:quiz_app/features/profile/profile_view.dart';
import 'package:quiz_app/utils/enums/assets_enums.dart';
import 'package:quiz_app/utils/models/user_info_model.dart';
import 'package:quiz_app/utils/scheme/color_scheme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../view_model/home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with HomeViewModel, SingleTickerProviderStateMixin {
  final String welcomeTitle = 'Hoşgeldin!\nDers çalışmaya hemen başla.';
  late TabController _tabController;
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbar(context),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.home),
                text: 'Ana Sayfa',
              ),
              Tab(
                icon: Icon(Icons.person),
                text: 'Profil',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(1.h),
                Text(
                  welcomeTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Gap(1.h),
                SizedBox(
                  width: 90.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          navigate(context, index);
                        },
                        child: _cards(context, index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const ProfileView()
        ]));
  }

  Container _cards(BuildContext context, int index) {
    return Container(
      height: 20.h,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.border.normalBorderRadius,
        border: Border.all(
          color: QuizColorScheme.fourthColor,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            listItems[index].path,
            height: 15.h,
          ),
          Text(
            listItems[index].title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.chevron_right)
        ],
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthenticationView(),
                  ));
            },
            icon: const Icon(Icons.logout))
      ],
      title: const Text(
        'Anasayfa',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            if (selectedIndex != value) selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ]);
  }
}
