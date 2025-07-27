import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/app_theme.dart';
class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const ShimmerListView({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 80.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: _buildListItem(context),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Container(
      height: itemHeight,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left placeholder (avatar)
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12.0),
          // Right content placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title placeholder
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                // Subtitle placeholder
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 14.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                // Additional info placeholder
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 12.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ShimmerGridView extends StatelessWidget {
  const ShimmerGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: GridView.builder(
        itemCount: 6, // Number of items in your grid view
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row
        ),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              margin: const EdgeInsets.all(8.0),
              width: 50,
              height: 20,

            ),
          );
        },
      ),
    );
  }

static Padding padding(double height,double width) {
  return Padding(
    padding: paddingSemetricVerticalHorizontal(h: 18),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width:width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white, // You can set a background color for the shimmer effect
          borderRadius: BorderRadius.circular(20),

        ), // Optionally, you can set a background color
      ),
    ),
  );
}
}