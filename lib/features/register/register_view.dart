import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:kartal/kartal.dart';
import 'package:quiz_app/features/home/view/home_view.dart';
import 'package:quiz_app/utils/models/user_info_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends ConsumerState<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  String? _grade;
  String? _field;
  final userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(userID ?? 'diger')
            .set(UserInfoModel(
                    name: _nameController.text, field: _field!, grade: _grade!)
                .toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bilgileriniz başarıyla kaydedildi!')),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeView(),
            ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Bir hata oluştu, lütfen tekrar deneyin!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sizi daha fazla tanımak istiyoruz',
                style: context.general.textTheme.headlineSmall,
              ),
              Gap(5.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ad Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı ve soyadınızı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _grade,
                onChanged: (newValue) {
                  setState(() {
                    _grade = newValue;
                  });
                },
                items: ['9', '10', '11', '12']
                    .map((grade) => DropdownMenuItem(
                          value: grade,
                          child: Text(grade),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Sınıf'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen sınıfınızı seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _field,
                onChanged: (newValue) {
                  setState(() {
                    _field = newValue;
                  });
                },
                items: ['Sayısal', 'Sözel', 'Eşit Ağırlık']
                    .map((field) => DropdownMenuItem(
                          value: field,
                          child: Text(field),
                        ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Alan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen alanınızı seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
