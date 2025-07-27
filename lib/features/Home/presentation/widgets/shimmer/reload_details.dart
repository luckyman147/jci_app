import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/presentation/widgets/shimmer/Shimmer_helpers.dart';
import 'package:shimmer/shimmer.dart';


class ReloadDetailsPage extends StatelessWidget {
  const ReloadDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big picture with shimmer effect
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300]!,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            // Containers with shimmer effect
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  const CustomContainer(),

                  ShimmerHelpers.buildShimmerRow(),
                  ShimmerHelpers.buildShimmerRow(),

                  const CustomContainer(),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }

}


class CustomContainer extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomContainer({
    Key? key,
    this.height = 100.0,
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    this.padding = const EdgeInsets.all(10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
