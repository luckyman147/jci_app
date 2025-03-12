import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PVLoadingWidget extends StatelessWidget {
  const PVLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.0,
      width: double.infinity,
      child: ListView.builder(
        itemCount: 2, // You can change this to the number of items you want to show as placeholders
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                height: 120.0,
                color: Colors.white,
                child: Row(
                  children: [
                    // Oval placeholder for icon
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    // Placeholder for title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.0,
                          height: 20.0,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 250.0,
                          height: 15.0,
                          color: Colors.grey[200],
                        ),
                        const SizedBox(height: 8.0),
                        // Placeholder for date
                        Container(
                          width: 100.0,
                          height: 15.0,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
