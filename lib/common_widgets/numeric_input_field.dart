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
      style: TextStyle(
        color: Colors.purple, // Change this to your desired text color
        fontSize: 18, // You can also change the font size
      ),
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white, // Set background color to white
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
