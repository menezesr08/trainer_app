import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double value;
  final String category;
  final double userPerformance;
  final double progress;

  const ProgressBar(
      {super.key,
      required this.value,
      required this.category,
      required this.userPerformance,
      required this.progress});

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation =
        Tween<double>(begin: 0, end: widget.progress).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.category,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  final dynamic tooltip = _key.currentState;
                  tooltip.ensureTooltipVisible();
                },
                child: Tooltip(
                  key: _key,
                  message: ' ${widget.value.toInt()} kg',
                  height: 60.0,
                  child: const Icon(
                    Icons.info_outline,
                    size: 18,
                  ),
                ),
              )
            ],
          ),
          Stack(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * _animation.value,
                    decoration: BoxDecoration(
                      color: widget.progress == 1 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
