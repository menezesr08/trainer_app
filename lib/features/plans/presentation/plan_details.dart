import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/constants/colors.dart';
import 'package:trainer_app/features/plans/presentation/plans_providers.dart';

class PlanDetails extends ConsumerStatefulWidget {
  const PlanDetails({super.key});

  @override
  ConsumerState<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends ConsumerState<PlanDetails> {
  @override
  Widget build(BuildContext context) {
    final exercisesList = ref.read(selectedExercises);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text('Give us some more info'),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      right: 10.0), // Adjust the value as needed
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Background color of the circle
                    ),
                    child: Icon(Icons.check,
                        color: Colors.green,
                        size: 24), // Icon inside the circle
                  ),
                ),
              ]),
          body: Container(
            color: Colors.black,
            child: Column(
              children: [
                ...exercisesList.map((element) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      ExerciseInput(exercise: element),
                      // Add SizedBox with desired height between ExerciseInput widgets
                    ],
                  );
                }).toList(),
              ],
            ),
          )),
    );
  }
}

class ExerciseInput extends StatelessWidget {
  const ExerciseInput({
    super.key,
    required this.exercise,
  });

  final String exercise;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: textColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  exercise,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Reps'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          // Handle value changes
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Sets'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          // Handle value changes
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Weight'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          // Handle value changes
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
