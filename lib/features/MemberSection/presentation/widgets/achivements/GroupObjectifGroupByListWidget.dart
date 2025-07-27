import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/objectifsIcon.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../../core/app_theme.dart';
import '../../../domain/entity/UserObjectifInfos.dart';
import '../../../global-pres.dart';
import 'AchivementsWidget.dart';

class GroupedObjectifsListWidget extends StatelessWidget {
  final Map<String, List<UserObjectifInfos>> groupBYObjectifs;
  final bool hasReachedMax;
  final Function loadMoreCallback;
  final String id;

  GroupedObjectifsListWidget({
    required this.groupBYObjectifs,
    required this.hasReachedMax,
    required this.loadMoreCallback, required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: hasReachedMax ? groupBYObjectifs.length : groupBYObjectifs.length + 1,
      itemBuilder: (context, index) {
        if (index < groupBYObjectifs.length) {
          // Get the group key (e.g., Difficulty, Privacy, etc.)
          String groupKey = groupBYObjectifs.keys.elementAt(index);
          // Get the list of items for the group
          final groupItems = groupBYObjectifs[groupKey]!;

          return
            groupItems.isEmpty ? Container() :

            GroupedObjectifWidget(
            groupKey: groupKey,
            groupItems: groupItems, id: id,
          );
        }

        // Load more button
        return TextButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: ColorsApp.textColorBlack),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => loadMoreCallback(),
          child: Text(
            "Load More".tr(context),
            style: PoppinsNorml(18.sp, ColorsApp.textColorBlack),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 11);
      },
    );
  }
}

class GroupedObjectifWidget extends StatelessWidget {
  final String groupKey;
  final List<UserObjectifInfos> groupItems;
  final String id;

  GroupedObjectifWidget({
    required this.groupKey,
    required this.groupItems, required this.id,
  });

  @override
  Widget build(BuildContext context) {
    List<ValueNotifier<bool>> expandStates =
    List.generate(groupItems.length, (_) => ValueNotifier<bool>(false));

    return Padding(
      padding: paddingSemetricVertical(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group header (e.g., Difficulty, Privacy, etc.)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              groupKey.doublesWords.capitalize().tr(context).capitalize(),
              style: PoppinsSemiBold(18.sp, ColorsApp.textColorBlack, TextDecoration.none),
            ),
          ),
          // List of items in this group
            ...groupItems.map((item) {
              return Padding(
                padding:paddingSemetricVertical(),
                child: AchievementWidget(
                  userObjectif: item.userObjectif,
                  objectif: item.objectif, isExpanded: expandStates[groupItems.indexOf(item)], memberid: id,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

extension on String {
  String capitalize() {
    if (this !=null && this.isNotEmpty) {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
    return this;
  }
}
