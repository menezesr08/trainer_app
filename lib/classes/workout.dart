class Workout {
  String name;
  int numberOfSets;
  int minNumberOfReps;
  int maxNumberOfReps;

  Workout(
      {required this.name,
      required this.numberOfSets,
      required this.minNumberOfReps,
      this.maxNumberOfReps = 10});

    
}
