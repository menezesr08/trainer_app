import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/constants/enums.dart';
import 'package:trainer_app/features/onboarding/data/models/onboarding_data.dart';
import 'package:trainer_app/features/user/domain/user_preferences.dart';
import 'package:trainer_app/providers/auth_providers.dart';
import 'package:trainer_app/providers/user_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  late int numGymSessions;
  late int age;
  late int bodyWeight;
  int _gymSessionsPerWeek = 3;
  Gender? _selectedGender;
  int _dailyCalories = 2000;
  double _hoursOfSleep = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Some info about you'),
              TextFormField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'BodyWeight (kg)'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  bodyWeight = int.parse(value!);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Select your gender:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  ListTile(
                    title: const Text('Male'),
                    leading: Radio<Gender>(
                      value: Gender.male,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Female'),
                    leading: Radio<Gender>(
                      value: Gender.female,
                      groupValue: _selectedGender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gym sessions per week'),
                keyboardType: TextInputType.number,
                initialValue: '$_gymSessionsPerWeek',
                onSaved: (value) {
                  _gymSessionsPerWeek = int.parse(value!);
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Calories per day'),
                keyboardType: TextInputType.number,
                initialValue: '$_dailyCalories',
                onSaved: (value) {
                  _dailyCalories = int.parse(value!);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text('Hours of sleep per day'),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 10.0,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 15.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 30.0),
                      tickMarkShape:
                          RoundSliderTickMarkShape(tickMarkRadius: 8.0),
                      thumbColor: Colors.lightBlue,
                      overlayColor: Colors.blue.withOpacity(0.2),
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    child: Slider(
                      value: _hoursOfSleep,
                      min: 4,
                      max: 12,
                      divisions: 8,
                      label: _hoursOfSleep.round().toString(),
                      onChanged: (value) {
                        setState(() {
                          _hoursOfSleep = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _submitForm(),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authRepository = ref.read(authRepositoryProvider);
      final userId = authRepository.currentUser!.uid;

      final userRepository = ref.read(userRepositoryProvider);

      final preferences = UserPreferences(
        gymSessionsPerWeek: _gymSessionsPerWeek,
        dailyCalories: _dailyCalories,
        hoursOfSleep: _hoursOfSleep.round(),
      );

      final data = OnboardingData(
        gender: _selectedGender,
        age: age,
        bodyWeight: bodyWeight,
        preferences: preferences,
      );

      userRepository.setOnboardingData(userId, data);

      GoRouter.of(context).push('/plans');
    }
  }
}
