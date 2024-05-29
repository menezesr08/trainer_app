final Map<String, Gender> stringToGenderMap = {
  'male': Gender.male,
  'female': Gender.female,
};

final Map<Gender, String> genderToStringMap =
    stringToGenderMap.map((key, value) => MapEntry(value, key));

enum Gender { male, female }
