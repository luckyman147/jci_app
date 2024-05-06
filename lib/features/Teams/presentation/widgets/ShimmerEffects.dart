

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListViewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: paddingSemetricHorizontal(h: 30),
        child: Container(
          height: 200,

          width: MediaQuery.of(context).size.width*.5,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildContainer(20,MediaQuery.of(context).size.width*.6),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           buildContainer(20,MediaQuery.of(context).size.width*.2),
                           buildContainer(30,MediaQuery.of(context).size.width*.2),


                          ],
                        ),

                        SizedBox(height:18.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          buildContainer(30, MediaQuery.of(context).size.width*.2),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                buildAlign(),
                                buildAlign(),
                                buildAlign(),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer(double height,double width) {
    return Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[300],
                        ),

                      );
  }

  Align buildAlign() {
    return Align(
                                widthFactor: .4,
                                child: Container(
                                  height: 30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textColorWhite),
                                 shape: BoxShape.circle,
                                    color: Colors.grey[300],
                                  ),

                                ),
                              );
  }
}

class ShimmerListView extends StatelessWidget {
  final int itemCount;

  const ShimmerListView({Key? key, required this.itemCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerListViewItem();
      },
    );
  }
}
