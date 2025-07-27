import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/TeamMeta.dart';
import 'package:jci_app/features/projectFeature/data/models/ProjectModel.dart';

import '../../../../core/config/services/uploadImage.dart';
import '../../../common/enums/PrivacyType.dart';
import '../../presentation/enum/ProjectCreationStep.dart';

abstract class ProjectRemoteDataSources{
  // Create a new project
  Stream<ProjectCreationStatus> createProject(ProjectModel project) ;
  // Update an existing project
  Future<Unit> updateProject(ProjectModel project);

  // Delete a team from a project
  Future<Unit> deleteTeamFromProject(String projectId, String teamId);

  // Delete a project
  Future<Unit> deleteProject(String projectId);

  // Get a project by its ID
  Future<ProjectModel> getProjectById(String projectId);

  // Get all projects with specified privacy type
  Future<List<ProjectModel>> getAllProjects(PrivacyType privacy);

}

class ProjectRemoteDataSourcesImpl implements ProjectRemoteDataSources {
 final FirebaseFirestore firestore;
 final FirebaseImageUploader firebaseImageUploader;
  ProjectRemoteDataSourcesImpl(this.firebaseImageUploader, {required this.firestore});
 @override
 Stream<ProjectCreationStatus> createProject(ProjectModel project) async* {
   try {
     final teamsCollection = firestore.collection('teams');
     final List<TeamMeta> updatedTeams = [];

     yield ProjectCreationStatus(step: ProjectCreationStep.creatingTeams);

     // 1. Create teams
     for (var i = 0; i < project.teamsInfos.length; i++) {
       final team = project.teamsInfos[i];
       final teamRef = await teamsCollection.add(
         team.copyWith(projectId: null).toJson(),
       );

       final createdTeam = team.copyWith(id: teamRef.id);
       updatedTeams.add(createdTeam);

       yield ProjectCreationStatus(
         step: ProjectCreationStep.creatingTeams,
         message: 'Created team ${i + 1}/${project.teamsInfos.length}',
         progress: (i + 1) / project.teamsInfos.length,
       );
     }

     yield ProjectCreationStatus(step: ProjectCreationStep.teamsCreated);

     // 2. Create project
     yield ProjectCreationStatus(step: ProjectCreationStep.creatingProject);

     final projectRef = firestore.collection('projects').doc();
     final newProject = project.copyWith(
       id: projectRef.id,
       teamInfos: updatedTeams,
     );

     await projectRef.set(newProject.toJson());

     yield ProjectCreationStatus(
       step: ProjectCreationStep.projectCreated,
       project: newProject,
     );

     // 3. Update teams with projectId
     yield ProjectCreationStatus(step: ProjectCreationStep.updatingTeamsWithProjectId);

     for (var i = 0; i < updatedTeams.length; i++) {
       final team = updatedTeams[i];
       await teamsCollection.doc(team.id).update({'projectId': projectRef.id});

       yield ProjectCreationStatus(
         step: ProjectCreationStep.updatingTeamsWithProjectId,
         message: 'Updated team ${i + 1}/${updatedTeams.length}',
         progress: (i + 1) / updatedTeams.length,
       );
     }

     yield ProjectCreationStatus(
       step: ProjectCreationStep.teamsUpdated,
     );

     yield ProjectCreationStatus(
       step: ProjectCreationStep.completed,
       project: newProject,
     );
   } catch (e, st) {
     yield ProjectCreationStatus(
       step: ProjectCreationStep.failed,
       message: 'Error: ${e.toString()}',
     );

     throw FirebaseException(
       plugin: 'createProject',
       message: e.toString(),
       stackTrace: st,
     );
   }
 }


 @override
 Future<Unit> deleteProject(String projectId) async {
   try {
     final projectRef = firestore.collection('projects').doc(projectId);
     final teamsCollection = firestore.collection('teams');

     // 1. Delete all teams where projectId == projectId
     final teamsToDelete = await teamsCollection
         .where('projectId', isEqualTo: projectId)
         .get();

     for (final doc in teamsToDelete.docs) {
       await teamsCollection.doc(doc.id).delete();
     }

     // 2. Delete the project
     await projectRef.delete();

     return unit;
   } catch (e, st) {
     throw FirebaseException(
       plugin: 'deleteProject',
       message: e.toString(),
       stackTrace: st,
     );
   }
 }


  @override
  Future<Unit> deleteTeamFromProject(String projectId, String teamId) async{
    final docRef = firestore.collection("projects").doc(projectId);
    final snapshot = await docRef.get();

    final data = snapshot.data()!;
    final model = ProjectModel.fromJson(data);
    final updatedTeamIds =  model.teamsInfos
        .where((team) => team.id != teamId)

        .toList();

    final updated = model.copyWith(teamInfos: updatedTeamIds);
    await docRef.update(updated.toJson());
    return unit;
  }

 @override
 Future<List<ProjectModel>> getAllProjects(PrivacyType privacy) async {
   try {
     final snapshot = await firestore
         .collection('projects')
         .where('privacy', isEqualTo: privacy.name) // or .toString().split('.').last
         .get();

     return snapshot.docs
         .map((doc) => ProjectModel.fromJson(doc.data()).copyWith(id: doc.id))
         .toList();
   } catch (e, st) {
     throw FirebaseException(
       plugin: 'getAllProjects',
       message: e.toString(),
       stackTrace: st,
     );
   }
 }

 @override
 Future<ProjectModel> getProjectById(String projectId) async {
   try {
     final doc = await firestore.collection('projects').doc(projectId).get();

     if (!doc.exists) {
       throw FirebaseException(
         plugin: 'getProjectById',
         message: 'Project with ID $projectId not found',
       );
     }

     return ProjectModel.fromJson(doc.data()!).copyWith(id: doc.id);
   } catch (e, st) {
     throw FirebaseException(
       plugin: 'getProjectById',
       message: e.toString(),
       stackTrace: st,
     );
   }
 }

 @override
 Future<Unit> updateProject(ProjectModel project) async {
   final docRef = firestore.collection("projects").doc(project.id);
   await docRef.update(project.toJson());
   final updatedDoc = await docRef.get();
   return unit;
 }
}