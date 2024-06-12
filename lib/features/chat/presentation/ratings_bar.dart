import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final List<String> ratingLabels;
  final ValueChanged<int> onRatingChanged;
  final int selectedOption;
  const RatingBar(
      {super.key,
      required this.ratingLabels,
      required this.onRatingChanged,
      required this.selectedOption});

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  void _rate(int rating) {
    widget.onRatingChanged(rating);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.ratingLabels.length, (index) {
              int rating = index + 1;
              return GestureDetector(
                onTap: () => _rate(rating),
                child: Column(
                  children: [
                    Icon(
                      Icons.star,
                      color:widget.selectedOption >= rating
                          ? Colors.amber
                          : Colors.grey,
                      size: 40,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.ratingLabels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color:widget.selectedOption>= rating
                            ? Colors.amber
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
