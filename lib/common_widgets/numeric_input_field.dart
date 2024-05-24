import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  final void Function(String) callback;
  final TextEditingController controller;
  const NumericInputField(
      {super.key, required this.callback, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor:
            FlexColor.purpleBrownDarkSecondary, // Set background color to white
        border: OutlineInputBorder(
          // Add border
          borderSide: const BorderSide(color: Colors.purple), // Border color
          borderRadius: BorderRadius.circular(8.0), // Border radius
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0), // Optional: Adjust padding
      ),
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        callback(value);
      },
    );
  }
}
