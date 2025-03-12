import 'package:flutter/material.dart';
import 'MemberAllIn.dart';
 // Assuming you already have this widget for displaying the members

class MembersList extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final String memberName;

  const MembersList({
    Key? key,
    required this.mediaQuery,
    required this.memberName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: mediaQuery.size.height / 3,
          child: MembersFetchWidget(name:  memberName),
        ),
      ),
    );
  }
}
