


import 'package:cached_network_image/cached_network_image.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../MemberSection/global-pres.dart';


class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    super.key,
    required this.item,
    required this.height,
    required this.width,
  });

  final String? item;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Image.asset(
        images.PersonVip,
        width: width,
        height: height,
      );
    }
    return CachedNetworkImage(
      imageUrl: item!, // Image URL for caching
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!, // Light grey color for the base
        highlightColor: Colors.grey[100]!, // Lighter grey for the highlight
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[300], // Set the same color as baseColor for consistency
            borderRadius: BorderRadius.circular(8), // Optional: Add rounded corners
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        images.jci
        ,
        width: width,
        height: height,
      ), // Error widget
      width: width,
      height: height,

      fit: BoxFit.cover,
    );
  }
}
