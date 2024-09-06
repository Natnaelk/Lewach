import 'package:flutter/material.dart';

class BidCardWidget extends StatelessWidget {
  final Color color;
  final String title;
  final int numberOfBids;
  final double percentFinished;
  final String imagePath;
  const BidCardWidget({
    super.key,
    required this.color,
    required this.title,
    required this.numberOfBids,
    required this.percentFinished,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10),
      padding: const EdgeInsets.all(10),
      width: 170,
      height: 250,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          Text(
            '$numberOfBids Bids',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                imagePath,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
