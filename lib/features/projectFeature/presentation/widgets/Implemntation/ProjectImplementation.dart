import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Home/Activity_Global.dart';
import '../../bloc/Project/project_management_bloc.dart';

import '../ProjectComponent.dart'; // Adjust this import

class AllProjectsWidget extends StatelessWidget {
  const AllProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectManagementBloc, ProjectManagementState>(
      builder: (context, state) {
        switch (state.status) {
          case ProjectStateStatus.loading:
            return const Center(child: LoadingWidget());

          case ProjectStateStatus.LoadedProjects:
            return
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ProjectCard(project: project,);
              },
            ));

          case ProjectStateStatus.failure:
            return Center(child: Text(state.finalMessage ?? "Error loading projects"));

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
