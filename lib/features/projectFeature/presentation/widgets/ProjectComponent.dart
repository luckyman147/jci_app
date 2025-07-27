import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/common/enums/PrivacyType.dart';
import '../../../../core/strings/Images.string.dart';
import '../../domain/entities/Project.dart';


class ProjectCard extends StatelessWidget {
  final Project project;
  final ValueNotifier<bool> showTeamsNotifier = ValueNotifier(false);

  ProjectCard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with image + name
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: project.imageUrl != null
                      ? NetworkImage(project.imageUrl!)
                      : const AssetImage(images.jcihammem) as ImageProvider,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    project.name,
                    style: PoppinsSemiBold(15.sp, ColorsApp.textColorBlack,TextDecoration.none),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Privacy
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 18),
                const SizedBox(width: 6),
                AutoSizeText(
                  project.privacy.name,
                  style: PoppinsRegular(13.sp,
                    project.privacy == PrivacyType.Private
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Dropdown for Teams
            if (project.teamsInfos.isNotEmpty)
              ValueListenableBuilder<bool>(
                valueListenable: showTeamsNotifier,
                builder: (context, showTeams, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                        showTeamsNotifier.value = !showTeamsNotifier.value,
                        icon: Icon(showTeams
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                        label:
                        Text('Show Teams (${project.teamsInfos.length})'),
                      ),
                      if (showTeams)
                        ...project.teamsInfos.map(
                              (team) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.group),
                            title: Text(team.name),
                            subtitle: Text(' ${team.description}'),

                         //   trailing: Text(team.status.toString()),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
