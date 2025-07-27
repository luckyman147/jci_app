import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/presentation/widgets/shimmer/Shimmer_helpers.dart';
import 'package:shimmer/shimmer.dart';

class LoadNotesShimmer extends StatelessWidget {
  final int count;

  const LoadNotesShimmer({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: count,
      itemBuilder: (context, index) {
        return const NoteShimmerTile();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }
}
class NoteShimmerTile extends StatelessWidget {
  const NoteShimmerTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ShimmerHelpers. buildShimmerContainer(
             50,
              MediaQuery.of(context).size.width/1.5
          ),
        ),
      ),
    );
  }
}
