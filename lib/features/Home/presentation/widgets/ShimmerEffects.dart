import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ReloadDetailsPage extends StatelessWidget {
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

  static Widget buildshimmerreventlist() {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: paddingSemetricHorizontal(h: 10),
            child: Container(
              height: 250,
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildShimmerContainer(200, MediaQuery
                        .of(context)
                        .size
                        .width / 3),
                    Padding(
                      padding: paddingSemetricHorizontal(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildShimmerContainer(20, MediaQuery
                              .of(context)
                              .size
                              .width / 2.2),
                          buildShimmerContainer(20, MediaQuery
                              .of(context)
                              .size
                              .width / 2.3),
                          buildShimmerContainer(20, MediaQuery
                              .of(context)
                              .size
                              .width / 2.5),
                          buildShimmerContainer(20, MediaQuery
                              .of(context)
                              .size
                              .width / 2.5),

                          buildShimmerContainer(40, MediaQuery
                              .of(context)
                              .size
                              .width / 3),

                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
      return SizedBox(height: 10,);
    },
    );
  }

  static Widget ActivityMonth() {
    return SizedBox(
      height: 400, // Adjust the height as per your requirement
      child: ListView.separated(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: 400,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildShimmerContainer(150, MediaQuery
                          .of(context)
                          .size
                          .width / 1.2),
                      buildShimmerContainer(10, MediaQuery
                          .of(context)
                          .size
                          .width / 1.5),
                      buildShimmerContainer(20, MediaQuery
                          .of(context)
                          .size
                          .width / 1.5),
                      buildShimmerContainer(10, MediaQuery
                          .of(context)
                          .size
                          .width / 1.5),
                      buildShimmerContainer(10, MediaQuery
                          .of(context)
                          .size
                          .width / 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildShimmerContainer(50, MediaQuery
                              .of(context)
                              .size
                              .width / 2.5),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 10);
        },
      ),
    );
  }


  static Widget loadNotesShimer(int count ){
return    ListView.separated(itemBuilder: (context, index) {
      return Padding(
        padding: paddingSemetricVertical(),
        child: Container(
          height: 100,
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
          child: Padding(
            padding: paddingSemetricHorizontal(h: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildShimmerContainer(50, MediaQuery.of(context).size.width/1.5),

              ],
            ),
          ),
        ),
      );
    }, separatorBuilder: (BuildContext context, int index) {
      return SizedBox(height: 10,);
}, itemCount: count,);
  }


  static Widget buildShimmerContainer(double height, double width) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: height,
              width: width,

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            direction: ShimmerDirection.rtl,
            period: Duration(milliseconds: 1000),
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