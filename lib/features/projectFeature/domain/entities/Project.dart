import 'package:jci_app/features/MemberSection/domain/entity/ActionDetails.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/TeamMeta.dart';

import '../../../common/enums/PrivacyType.dart';

class Project {
  final String id;
  final String name;
  final String? imageUrl;
  final String description;
  final PrivacyType privacy;
  final List<TeamMeta> teamsInfos;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.privacy,
    this.imageUrl,
    required this.teamsInfos,

  });
}
