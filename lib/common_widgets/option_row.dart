import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class OptionRow extends StatelessWidget {
  const OptionRow({super.key, required this.title, required this.onTapped});
  final String title;
  final Function() onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.only(top: 0, left: 10),
        height: 60,
        width: double.maxFinite,
        decoration: BoxDecoration(
          border: Border.all(
            color: FlexColor.purpleBrownDarkSecondaryContainer, // Border color
            width: 3.0, // Border width
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              size: 35,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
