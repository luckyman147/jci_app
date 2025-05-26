import 'package:jci_app/core/Abstractions/Entity.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';

import '../../../../../features/MemberSection/domain/entity/ActionDetails.dart';
import '../../../../Abstractions/IEntity.dart';
enum CibleType { Members, NewMembers, VPs,President,Advisors,Secretary,CommittedMember }

class Role extends IEntity<String>{
final List<FeaturePermissions> permissions;
final CibleType RoleCategory;
final String roleName;





  @override
  String? id;

  Role({required this.permissions, required this.RoleCategory, required this.roleName,this.id=""});


  @override
  // TODO: implement props
  List<Object?> get props => [RoleCategory,permissions,roleName];
}