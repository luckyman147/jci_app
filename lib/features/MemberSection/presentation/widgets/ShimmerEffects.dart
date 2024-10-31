import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/app_theme.dart';

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


  static Widget hh( BuildContext context) {
    return SizedBox(
      height: 280,
      width: 350,
      child: Stack(
        children: [
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white, // You can set a background color for the shimmer effect
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white, // You can set a background color for the shimmer effect
                shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            left: 0,
            right: 0,
            child:  Column(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: const SizedBox(
                        height: 30,
                        width: 200,
                      )  ,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: const SizedBox(
                            height: 30,
                            width: 200,
                          )  ,
                        ),

                      ],
                    ),
                  ],
                )

            ),


          Positioned(
            top: 170,
            right: 0,
            left: 0,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: paddingSemetricHorizontal(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: paddingSemetricHorizontal(),
                      child:SizedBox(
                        height: 30,
                        width: 30,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white, // You can set a background color for the shimmer effect
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
  ) ,
                  ],
                ),
              ),
            ),
          ),
        ]
      ));
  }
static Widget UserprofileShimmer(BuildContext ctx)=>SingleChildScrollView(
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
  
        Row(
          children: [
            padding(ctx, 20, 30),
            padding(ctx, 20, 100),
          ],
        ),
        padding(ctx, 10, 10)
      ],),
      hh(ctx),
      padding(ctx, 80, MediaQuery.of(ctx).size.width),
      padding(ctx, 80, MediaQuery.of(ctx).size.width),
      padding(ctx, 80, MediaQuery.of(ctx).size.width),
      padding(ctx, 80, MediaQuery.of(ctx).size.width),
  
    ],
  ),
);

static Padding padding(BuildContext ctx,double height,double width) {
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