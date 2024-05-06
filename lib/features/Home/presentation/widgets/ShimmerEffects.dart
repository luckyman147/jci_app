import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ReloadDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Big picture with shimmer effect
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                          child: Container(
                          height:MediaQuery.of(context).size.height/2.5,
                          width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: Offset(0, 3),
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
                    _buildContainer(),

                    buildShimmerRow(),
                    buildShimmerRow(),
                    _buildContainer(),
                  ],
                ),
              ),
            ],
          ),
        
      ),
    );
  }

  Widget buildShimmerRow() {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(h:20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            // Shimmer circle
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 20),
            // Column with shimmer text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 20,
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 5),
                ),
                Container(
                  width: 100,
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(10),
      height: 100, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }
}
class ShimmerButton {
  static Widget buildShimmerButton(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Specify base color for shimmer effect
      highlightColor: Colors.grey[100]!, // Specify highlight color for shimmer effect
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white, // Optional: Set background color for the button
          borderRadius: BorderRadius.circular(10), // Optional: Set border radius for the button
        ),
      ),
    );
  }

  static Widget shimmerparticipants()=>GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      childAspectRatio: 1.5, // Aspect ratio of each grid item
      // Number of columns in the grid
    ),
    itemCount: 4, // Number of items in the grid
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Specify base color for shimmer effect
        highlightColor: Colors.grey[100]!, // Specify highlight color for shimmer effect
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ))) ;

    },
  );
}