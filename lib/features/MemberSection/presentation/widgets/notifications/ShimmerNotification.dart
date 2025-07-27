import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/app_theme.dart';

class NotificationTileShimmer extends StatelessWidget {
  const NotificationTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First shimmer line (title)
              Container(
                width: 200.w,
                height: 18.h,
                color: ColorsApp.ThirdColor,
              ),
              SizedBox(height: 12.h),

              // Second shimmer line (subtitle)
              Container(
                width: double.infinity,
                height: 14.h,
                color: ColorsApp.ThirdColor,
              ),
              SizedBox(height: 8.h),

              // Third shimmer line (subtitle)
              Container(
                width: 250.w,
                height: 14.h,
                color: ColorsApp.textColor
              ),
              SizedBox(height: 16.h),

              // Footer row with text and button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text placeholder
                  Container(
                    width: 100.w,
                    height: 14.h,
                    color: ColorsApp.textColor,
                  ),

                  // Button placeholder
                  Container(
                    width: 80.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: ColorsApp.textColor,
                      borderRadius: BorderRadius.circular(13),
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
}
class ShimmernotificationList extends StatelessWidget {
  const ShimmernotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index)=>const NotificationTileShimmer(),
        separatorBuilder: (context,index)=>SizedBox(height: 10,), itemCount: 6);
  }
}
