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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.9),
              Colors.black.withOpacity(0.9),
            ],
            stops: const [0.0, 0.7],
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
