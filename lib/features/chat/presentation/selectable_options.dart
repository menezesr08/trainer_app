import 'package:flutter/material.dart';

class SelectableOptions extends StatefulWidget {
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
  State<SelectableOptions> createState() => _SelectableOptionsState();
}

class _SelectableOptionsState extends State<SelectableOptions> {
  @override
  Widget build(BuildContext context) {

  
    return Wrap(
      spacing: 10.0, // Horizontal spacing between options
      runSpacing: 10.0, // Vertical spacing between rows of options
      children: widget.options.map((option) {
        return GestureDetector(
          onTap: () => widget.onOptionSelected(option.value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color:
                  widget.selectedOption == option.value ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              option.label,
              style: TextStyle(
                fontSize: 12,
                color: widget.selectedOption == option.value
                    ? Colors.black
                    : Colors.white,
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
