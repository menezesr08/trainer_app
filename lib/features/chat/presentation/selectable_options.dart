import 'package:flutter/material.dart';

class SelectableOptions extends StatelessWidget {
  final List<SelectableOption> options;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;

  const SelectableOptions({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0, // Horizontal spacing between options
      runSpacing: 10.0, // Vertical spacing between rows of options
      children: options.map((option) {
        return GestureDetector(
          onTap: () => onOptionSelected(option.value),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: selectedOption == option.value ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              option.label,
              style: TextStyle(
                color: selectedOption == option.value ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SelectableOption {
  final String label;
  final String value;

  SelectableOption({required this.label, required this.value});
}