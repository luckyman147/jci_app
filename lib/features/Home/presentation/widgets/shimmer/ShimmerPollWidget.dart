import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerPollWidget extends StatelessWidget {
  const ShimmerPollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poll Title
            Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.grey,
            ),
            const SizedBox(height: 16.0),
            // Poll Options
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4, // Assuming 4 options in the poll
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      // Option Text Placeholder
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 14.0,
                        color: Colors.grey,
                      ),
                      const Spacer(),
                      // Percentage Bar Placeholder
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 14.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            // Submit Button Placeholder
            Container(
              width: double.infinity,
              height: 40.0,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
