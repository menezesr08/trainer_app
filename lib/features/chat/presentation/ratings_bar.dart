import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  final List<String> ratingLabels;
  final ValueChanged<int> onRatingChanged;

  RatingBar({
    required this.ratingLabels,
    required this.onRatingChanged,
  });

  @override
  _RatingBarState createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  int _selectedRating = 0;

  void _rate(int rating) {
    setState(() {
      _selectedRating = rating;
    });
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
                      color: _selectedRating >= rating
                          ? Colors.amber
                          : Colors.grey,
                      size: 40,
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.ratingLabels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: _selectedRating >= rating
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
