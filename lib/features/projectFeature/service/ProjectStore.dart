import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../../common/enums/PrivacyType.dart';
import '../data/models/ProjectModel.dart';



class ProjectStore {
  final SharedPreferences prefs;

  static const _draftKey = 'project_draft';
  static const _projectsKey = 'cached_projects';
  static const _projectByIdKey = 'project_by_id';

  ProjectStore(this.prefs);

  Future<void> saveDraft(ProjectModel project) async {
    final json = jsonEncode(project.toJson());
    await prefs.setString(_draftKey, json);
  }

  ProjectModel? getDraft() {
    final jsonString = prefs.getString(_draftKey);
    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      return ProjectModel.fromJson(map);
    }
    return null;
  }

  Future<void> saveProjects(List<ProjectModel> projects) async {
    final json = jsonEncode(projects.map((e) => e.toJson()).toList());
    await prefs.setString(_projectsKey, json);
  }

 Future< List<ProjectModel>> getProjects(PrivacyType privacyType)async {
    final jsonString = prefs.getString(_projectsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
          .where((project) => project.privacy == privacyType)
          .toList();
    }
    return [];
  }

  Future<void> saveProjectById(String id, ProjectModel project) async {
    final json = jsonEncode(project.toJson());
    await prefs.setString('$_projectByIdKey$id', json);
  }
  ProjectModel? getProjectById(String id) {
    final jsonString = prefs.getString('$_projectByIdKey$id');
    if (jsonString != null) {
      final map = jsonDecode(jsonString);
      return ProjectModel.fromJson(map);
    }
    return null;
  }

  clearDraft() async{
    await prefs.remove(_draftKey);
  }
}
