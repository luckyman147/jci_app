import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/presentation/widgets/shimmer/Shimmer_helpers.dart';

class ShimmerEventList extends StatelessWidget {
  const ShimmerEventList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width / 1.05,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                ShimmerHelpers.buildShimmerContainer(200, MediaQuery.of(context).size.width / 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ShimmerHelpers.buildShimmerContainer(20, MediaQuery.of(context).size.width / 2.2),
                    ShimmerHelpers.buildShimmerContainer(20, MediaQuery.of(context).size.width / 2.3),
                    ShimmerHelpers.buildShimmerContainer(20, MediaQuery.of(context).size.width / 2.5),
                    ShimmerHelpers.buildShimmerContainer(20, MediaQuery.of(context).size.width / 2.5),
                    ShimmerHelpers.buildShimmerContainer(20, MediaQuery.of(context).size.width / 3),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
    );
  }
}


class ActivityMonth extends StatelessWidget {
  const ActivityMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Adjust the height as per your requirement
      child: ListView.separated(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return const ActivityCard();
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}
class ActivityCard extends StatelessWidget {
  const ActivityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width / 1.8,
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
               ShimmerHelpers. buildShimmerContainer(
              150,
                 MediaQuery
                     .of(context)
                     .size
                     .width / 1.2,
              ),
              ShimmerHelpers. buildShimmerContainer(
                10,
                MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
              ),      ShimmerHelpers. buildShimmerContainer(
                20,
                MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
              ),      ShimmerHelpers. buildShimmerContainer(
                10,
                MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
              ),    ShimmerHelpers. buildShimmerContainer(
                10,
                MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  ShimmerHelpers. buildShimmerContainer(
                    50,
                    MediaQuery
                        .of(context)
                        .size
                        .width / 2,
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

