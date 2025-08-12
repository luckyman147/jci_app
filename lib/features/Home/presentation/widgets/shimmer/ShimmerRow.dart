import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerRow extends StatelessWidget {
  const ShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child:

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 160,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          )


    );
  }
}
