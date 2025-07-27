import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jci_app/core/strings/app_strings.dart';

import '../../../../../../core/PrimitiveUser/User.dart';
import '../../../../../../core/app_theme.dart';
import '../../components/stuff/NetworkCachedImageWidget.dart';

class MemberImageWidget extends StatelessWidget {
  final User item;
  final double height;
  final double size;
  final bool bools;
  final double width;

  const MemberImageWidget({super.key, 
    required this.item,
    required this.height,
    required this.size,
    required this.bools,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileImageWidget(item: item, height: height),
        const SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: AutoSizeText(
            '${item.firstName} ${item.lastName}',

            style: PoppinsSemiBold(
              size,
              ColorsApp.textColorBlack,
              TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
// Replace 'User' and 'vip' with your actual model and default image asset
class ProfileImageWidget extends StatelessWidget {
  final User item;
  final double height;
  final String defaultImagePath;

  const ProfileImageWidget({super.key, 
    required this.item,
    required this.height,
    this.defaultImagePath = vip, // Default fallback image
  });

  @override
  Widget build(BuildContext context) {
    return item.Images.isEmpty
        ? ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        height: height,
        width: height,
        child: Image.asset(defaultImagePath), // Default image asset
      ),
    )
        : ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImageWidget(item: item.Images[0], height: height, width: height,),
    );
  }
}
