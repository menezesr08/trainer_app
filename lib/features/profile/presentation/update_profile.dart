import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/profile/constants.dart';
import 'package:trainer_app/features/profile/providers.dart';
import 'package:trainer_app/features/user/data/user_repository.dart';
import 'package:trainer_app/features/user/domain/app_user.dart';

class UpdateProfile extends ConsumerStatefulWidget {
  const UpdateProfile({super.key});

  @override
  ConsumerState<UpdateProfile> createState() => _ConsumerUpdateProfileState();
}

class _ConsumerUpdateProfileState extends ConsumerState<UpdateProfile> {
  final formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? email;
  Gender? gender;
  int? age;
  int? weight;
  String? location;
  AppUser? currentUser;

  @override
  void dispose() {
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void setUser() async {
    final userRepo = ref.watch(userRepositoryProvider);
    if (currentUser == null) {
      return;
    }

    AppUser updatedUser = currentUser!.copyWith(
      email: _emailController.text,
      gender: gender,
      age: int.tryParse(_ageController.text),
      bodyWeight: int.tryParse(_weightController.text),
      location: _locationController.text,
    );

    await userRepo.setUser(updatedUser);

    ref.read(profileRefreshProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(getUserProvider);
    return user.when(
      data: (data) {
        currentUser = data;

        _emailController.text = data!.email;
        _ageController.text = data.age == null ? '' : data.age.toString();
        _weightController.text =
            data.bodyWeight == null ? '' : data.bodyWeight.toString();
        _locationController.text = data.location ?? '';
        return WillPopScope(
          onWillPop: () async {
            if (formGlobalKey.currentState!.validate()) {
              setUser();
              return true; // Allow back navigation
            } else {
              return false; // Prevent back navigation if form is not valid
            }
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Execute your function here
                  setUser();
                },
              ),
              title: const Text('Your details'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: formGlobalKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<Gender>(
                      value: data.gender, // gender is the selected value
                      onChanged: (newValue) {
                        setState(() {
                          gender = newValue;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        // Add any additional decoration properties here
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Gender.male,
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: Gender.female,
                          child: Text('Female'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType
                          .number, // Specify keyboard type to show numerical keypad
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(labelText: 'Age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        age = int.tryParse(value ?? '');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _weightController,
                      decoration: const InputDecoration(labelText: 'Weight'),
                      keyboardType: TextInputType
                          .number, // Specify keyboard type to show numerical keypad
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your weight';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        weight = int.tryParse(value ?? '');
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        location = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) =>
          const CircularProgressIndicator(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
