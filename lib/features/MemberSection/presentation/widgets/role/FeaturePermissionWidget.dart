// feature_permissions_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Feature.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/app_theme.dart';

class FeaturePermissionsWidget extends StatelessWidget {
  const FeaturePermissionsWidget({super.key, required this.features});
final List<Feature> features;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/2.2,
      child: ListView.builder(


        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return _FeatureCard(feature: feature);
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Feature feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feature.featureName,
              style: PoppinsSemiBold(15, ColorsApp.textColorBlack, TextDecoration.none),
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: PoppinsRegular(14.sp, ColorsApp.ThirdColor),
            ),
            const SizedBox(height: 16),
            _PermissionToggles(feature: feature),
          ],
        ),
      ),
    );
  }
}

class _PermissionToggles extends StatelessWidget {
  final Feature feature;

  const _PermissionToggles({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: feature.permissions.map((permission) {
       return  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              permission.type.toString().split('.').last.replaceAll('can', ''),
              style: PoppinsRegular(
                14.sp,
                 permission.isGranted
                    ? ColorsApp.PrimaryColor
                    : ColorsApp.ThirdColor,
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: permission.isGranted,
              onChanged: (value) {
                context.read<FeaturesCubit>()
                    .onTogglePermission(feature.featureId, permission.type);
              },
              activeColor: ColorsApp.PrimaryColor,
              activeTrackColor: ColorsApp.PrimaryColor.withOpacity(0.4),
              inactiveThumbColor: ColorsApp.BackWidgetColor,
              inactiveTrackColor: ColorsApp.textColor,
            ),
          ],
        );
      }).toList(),
    );
  }
}