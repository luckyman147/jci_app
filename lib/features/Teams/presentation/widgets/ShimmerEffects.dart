

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'funct.dart';

class ShimmerListViewItem extends StatelessWidget {
  const ShimmerListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: paddingSemetricHorizontal(h: 30),
        child: Container(
          height: 200,

          width: MediaQuery.of(context).size.width*.5,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
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
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildContainer(20,MediaQuery.of(context).size.width*.6),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             buildContainer(20,MediaQuery.of(context).size.width*.2),
                             buildContainer(30,MediaQuery.of(context).size.width*.2),


                            ],
                          ),

                          const SizedBox(height:18.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            buildContainer(30, MediaQuery.of(context).size.width*.2),
                              const SizedBox(height: 8.0),
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
        return const ShimmerListViewItem();
      },
    );
  }
}
class ShimmerLoadingScreen extends StatelessWidget {
  const ShimmerLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, ste) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      TeamFunction.    ReturnFunbction(context, ste);
                    },
                  ),
               buildAlign(),
                  const SizedBox(width: 10),
                  buildContainer(20, 100)
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                   children:[
                    buildAlign(),
                    buildAlign(),
                   ]
                 ),
               ),
                const SizedBox(height: 10),
                buildContainer(20, double.infinity),
                const SizedBox(height: 10),
                buildContainer(20, double.infinity),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child:                 buildContainer(20, double.infinity),

                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildContainer(30, 60),
                    buildContainer(30, 60),
                  ],
                ),
                const SizedBox(height: 10),

                buildContainer(30, double.infinity),

              ],
            ),
          ),
        ],
      ),
    );
  },
);
  }
 static  Align buildAlign() {
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
 static Container buildContainer(double height,double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[300],
      ),

    );
  }
}
class TaskShimmer extends StatelessWidget {
  const TaskShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
  itemBuilder: (context, index) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 16.0,),
      child: ShimmerLoadingScreen.buildContainer(50, double.infinity),
    );
  }, separatorBuilder: (BuildContext context, int index) {
    return const  SizedBox(height: 10);
      }, itemCount: 3,
),
    );
  }
}


