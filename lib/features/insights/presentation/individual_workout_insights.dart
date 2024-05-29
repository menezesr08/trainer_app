import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trainer_app/features/insights/presentation/graph.dart';
import 'package:trainer_app/features/workouts/data/workouts_repository.dart';

import 'package:trainer_app/features/workouts/domain/base_workout.dart';

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

    return completedWorkoutsStream.when(
      data: (data) {
        final filteredData = data
            .where((element) => element.workoutId == widget.w.id)
            .toList()
          ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

        final maxWeight = filteredData.fold(
            0, (max, w) => w.maxWeight > max ? w.maxWeight : max);

        return Column(
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
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Graph(
                cw: filteredData,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    data: maxWeight.toString(),
                  ),
                ),
                autoFlipDuration: const Duration(
                    seconds:
                        2), // The flip effect will work automatically after the 2 seconds
              ),
              buildCustomContainer('Personal Target Met', const IconWidget(),
                  personalTarget: true),
            ]),
          ],
        );
      },
      loading: () {
        // Render loading indicator
        return const CircularProgressIndicator();
      },
      error: (error, stackTrace) {
        // Render error UI
        return Text('Error: $error');
      },
    );
  }

  Widget buildCustomContainer(String title, Widget data,
      {bool personalTarget = false}) {
    return Container(
      width: 100,
      height: 150,
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
        size: 50,
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
              fontSize: 30,
              color: Color(0xFF333333),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
