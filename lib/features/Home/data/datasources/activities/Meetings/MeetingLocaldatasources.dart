import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/CommentModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import '../../../../../../core/config/services/verification.dart';

abstract class MeetingLocalDataSource {
  Future<List<MeetingModel>> getAllCachedMeetings();
  Future<MeetingModel?> getCachedMeetingById(String id);
  Future<List<MeetingModel>> getCachedMeetingsOfTheWeek();
  Future<List<MeetingModel>> getCachedMeetingsOfTheMonth();

  Future<Unit> cacheMeetings(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheWeek(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheMonth(List<MeetingModel> Meeting);
  Future<Unit> saveExcelFile(Uint8List bytes, String filename);

  Future<bool> checkPermissions();

  Future<void> deleteMeeting(String id);
  Future<void> cacheMeeting(MeetingModel result);
  Future<void> cacheMeetingById(MeetingModel result);
}

class MeetingLocalDataSourceImpl implements MeetingLocalDataSource {
  final MeetingStore meetingStore;
  final Store store;
  MeetingLocalDataSourceImpl(this.store, {required this.meetingStore});
  @override
  Future<Unit> cacheMeetings(List<MeetingModel> Meeting) async {
    await MeetingStore.cacheMeetings(Meeting);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheMeetingsOfTheMonth(List<MeetingModel> Meeting) async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> cacheMeetingsOfTheWeek(List<MeetingModel> Meeting) async {
    throw UnimplementedError();
  }

  @override
  Future<List<MeetingModel>> getAllCachedMeetings() async {
    final Meetings = await MeetingStore.getCachedMeetings();
    if (Meetings.isNotEmpty) {
      return Meetings.toSet().toList();
    } else {
      return [];
    }
  }

  @override
  Future<MeetingModel?> getCachedMeetingById(String id) async {
    final result = await MeetingStore.getCachedMeetingById(id);
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  @override
  Future<List<MeetingModel>> getCachedMeetingsOfTheMonth() async {
    throw UnimplementedError();
  }

  @override
  Future<List<MeetingModel>> getCachedMeetingsOfTheWeek() async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> saveExcelFile(Uint8List bytes, String filename) async {
    final directory = await getExternalStorageDirectory();
    final downloadsDir = Directory(
        '/storage/emulated/0/Download'); // Default path for downloads on most Android devices

    // Ensure the Downloads directory exists
    if (!downloadsDir.existsSync()) {
      await downloadsDir.create(recursive: true);
    }

    // Check if a file with the same name already exists and add an index if necessary
    String filePath = p.join(downloadsDir.path, filename);
    String baseName = p.basenameWithoutExtension(filename);
    String extension = p.extension(filename);
    int index = 1;

    while (await File(filePath).exists()) {
      filePath = p.join(downloadsDir.path, '$baseName($index)$extension');
      index++;
    }

    // Create the file in the Downloads directory
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    // Log the directory path for debugging purposes
    log('File saved to: $filePath');

    return Future.value(unit);
  }

  @override
  Future<bool> checkPermissions() async {
    final eventPermission = await MeetingStore.getmeetPermissions();
    final userPermissions = store.getPermissions();
    if (eventPermission.isEmpty || userPermissions!.isEmpty) {
      return false;
    } else {
      return hasCommonElement(eventPermission, userPermissions) ? true : false;
    }
  }

  @override
  Future<void> deleteMeeting(String id) async {
    try {
      await MeetingStore.deleteMeeting(id);
    } catch (e) {
      throw NotFoundException();
    }
  }

  @override
  Future<void> cacheMeeting(MeetingModel result) async {
    try {
      await MeetingStore.cacheMeeting(result);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> cacheMeetingById(MeetingModel result) async {
    try {
      await MeetingStore.cacheMeetingById(result);
    } catch (e) {
      throw ServerException();
    }
  }
}
