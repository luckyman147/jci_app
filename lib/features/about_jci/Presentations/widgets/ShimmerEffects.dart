import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_theme.dart';

class ShimmerEffects{
  static ShimmerYearsButton()=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),

                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 10);
              },
            ),
          ),
        ],
      ),
    ),
  );

 static Widget shimmerCircle(double height, double width) {
    return Center(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  static Widget PresidensShimmer(bool ismax){
    return GridView.builder(
      // Add this line
      itemCount:ismax? 6:1,

      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        childAspectRatio: .8,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        maxCrossAxisExtent: 380.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return body();
      },
    );
  }

  static Widget body() {

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 150,
        width: 380,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
      ),
    );


    // Rest of the method implementation
  }





}class ShimmerPostsWidget extends StatelessWidget {
  const ShimmerPostsWidget({super.key});




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, priorityIndex) {

              return
              GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
    gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
    mainAxisSpacing: 10,
    crossAxisSpacing: 20,
    crossAxisCount: 2, // Number of columns
    childAspectRatio: .8, // Aspect ratio of items
    ),
    itemCount: 6,
    itemBuilder: (context, postIndex) {
return    ChildBody();
    },
    );
    }


    ,
          ),
        ),
      ),
    );

  }
  Container ChildBody( ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(v: 15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: getPOSTWidget(

          ),
        ),
      ),
    );
  }

  Widget getPOSTWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                pho(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: SizedBox(
                      height: 20,
                      width: double.infinity,
                      child: Container(color: Colors.white),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pho( ) {
    return  Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: textColor, width: 4.0),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.grey[300]!,

        ),
      ),
    );

  }


}
