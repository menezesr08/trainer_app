import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  final void Function(String) callback;
  const NumericInputField({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0),
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
