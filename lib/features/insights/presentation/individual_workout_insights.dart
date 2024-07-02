import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trainer_app/features/insights/presentation/graph.dart';
import 'package:trainer_app/features/insights/presentation/progress_bar.dart';

import 'package:trainer_app/features/workouts/domain/base_workout.dart';
import 'package:trainer_app/providers/user_providers.dart';
import 'package:trainer_app/providers/workouts_providers.dart';

class ProgressData {
  final String category;
  final double value;
  final double progress;

  ProgressData(this.category, this.value, this.progress);
}

double calculateProgress(
  double weight,
  double lowerBound,
  double upperBound,
) {
  if (weight > upperBound) {
    return 1;
  } else if (weight > lowerBound && weight <= upperBound) {
    return (weight - lowerBound) / (upperBound - lowerBound);
  } else {
    return 0;
  }
}

class IndividualWorkoutInsights extends ConsumerStatefulWidget {
  const IndividualWorkoutInsights({super.key, required this.w});
  final BaseWorkout w;

  @override
  ConsumerState<IndividualWorkoutInsights> createState() =>
      _ConsumerIndividualWorkoutInsightsState();
}

class _ConsumerIndividualWorkoutInsightsState
    extends ConsumerState<IndividualWorkoutInsights> {
  @override
  Widget build(BuildContext context) {
    final completedWorkoutsStream = ref.watch(completedWorkoutsProvider);
    final user = ref.watch(getUserProvider);

    return user.when(
      data: (user) {
        if (user == null) {
          return Center(child: Text('No user data available'));
        }

        return completedWorkoutsStream.when(
          data: (data) {
            final filteredData = data
                .where((element) => element.workoutId == widget.w.id)
                .toList()
              ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

            final maxWeight = filteredData
                .fold(0, (max, w) => w.maxWeight > max ? w.maxWeight : max)
                .toDouble();

            double bodyweight = user.bodyWeight!.toDouble();
            double beginnerValue = calculateBeginner(bodyweight);
            double noviceValue = calculateNovice(bodyweight);
            double intermediateValue = calculateIntermediate(bodyweight);
            double advancedValue = calculateAdvanced(bodyweight);

            double beginnerProgress =
                calculateProgress(maxWeight, 0, beginnerValue);
            double noviceProgress =
                calculateProgress(maxWeight, beginnerValue, noviceValue);
            double intermediateProgress =
                calculateProgress(maxWeight, noviceValue, intermediateValue);
            double advancedProgress =
                calculateProgress(maxWeight, intermediateValue, advancedValue);

            // Ensure only achievable bars fill up
            List<ProgressData> progressData = [
              ProgressData('Beginner', beginnerValue, beginnerProgress),
              ProgressData('Novice', noviceValue, noviceProgress),
              ProgressData(
                  'Intermediate', intermediateValue, intermediateProgress),
              ProgressData('Advanced', advancedValue, advancedProgress),
            ];

            return WillPopScope(
              onWillPop: () async {
                GoRouter.of(context).pop();
                return true;
              },
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.w.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 220,
                    width: 380,
                    child: Graph(
                        cw: filteredData,
                        user: user // Pass user bodyweight here
                        ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: progressData.map((data) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ProgressBar(
                          category: data.category,
                          value: data.value,
                          progress: data.progress,
                          userPerformance: maxWeight,
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlipCard(
                        fill: Fill
                            .fillBack, // Fill the back side of the card to make in the same size as the front.
                        direction: FlipDirection.HORIZONTAL, // default
                        side: CardSide.FRONT, // The side to initially display.
                        front: buildCustomContainer(
                          'Number of workouts',
                          TextWidget(data: filteredData.length.toString()),
                        ),
                        back: buildCustomContainer(
                          'Max weight',
                          TextWidget(
                            data: maxWeight.toInt().toString(),
                          ),
                        ),
                        autoFlipDuration: const Duration(
                            seconds:
                                2), // The flip effect will work automatically after the 2 seconds
                      ),
                      buildCustomContainer(
                        'Personal Target Met',
                        const IconWidget(),
                        personalTarget: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              Center(child: Text('Error loading workouts: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Error loading user: $error')),
    );
  }

  Widget buildCustomContainer(String title, Widget data,
      {bool personalTarget = false}) {
    return Container(
      width: 100,
      height: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: personalTarget
            ? FlexColor.redDarkPrimaryContainer
            : const Color(0xFFF5F5F5),
        border: Border.all(
          color: Colors.black, // Soft blue border
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          const BoxShadow(
            color: Colors.black, // Light gray shadow
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            textAlign: TextAlign.center,
          ),
          const Divider(
            color: Color(0xFFCCCCCC),
            thickness: 2,
            height: 20,
          ),
          // Add more content below the line if needed
          data
        ],
      ),
    );
  }
}

class IconWidget extends StatelessWidget {
  const IconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
          child: Icon(
        Icons.close,
        size: 35,
      )),
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          data,
          style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

double calculateBeginner(double bodyweight) {
  return 0.7 * bodyweight + 5;
}

double calculateNovice(double bodyweight) {
  return 1.5 * bodyweight + 28;
}

double calculateIntermediate(double bodyweight) {
  return 2.5 * bodyweight + 7;
}

double calculateAdvanced(double bodyweight) {
  return 3.2 * bodyweight - 1;
}
