import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/data/model/NoteModel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../../../core/config/services/MeetingStore.dart';
import '../../../../../core/error/Exception.dart';
import '../../model/meetingModel/MeetingModel.dart';
import 'package:path/path.dart' as p;

abstract class MeetingLocalDataSource {
  Future<List<MeetingModel>> getAllCachedMeetings();
  Future<MeetingModel> getCachedMeetingById(String id);
  Future<List<MeetingModel>> getCachedMeetingsOfTheWeek();
  Future<List<MeetingModel>> getCachedMeetingsOfTheMonth();
Future<Unit> cacheNotes(List<NoteModel> notes,String start,String limit);
Future<List<NoteModel>> getNotes(String start,String limit);

  Future<Unit> cacheMeetings(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheWeek(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheMonth(List<MeetingModel> Meeting);
  Future<Unit> saveExcelFile(Uint8List bytes, String filename);

}

class MeetingLocalDataSourceImpl implements MeetingLocalDataSource{
  @override
  Future<Unit> cacheMeetings(List<MeetingModel> Meeting)async {
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
    final Meetings=await MeetingStore.getCachedMeetings();
    if (Meetings.isNotEmpty) {
      return Meetings;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<MeetingModel> getCachedMeetingById(String id) {
    // TODO: implement getCachedMeetingById
    throw UnimplementedError();
  }

  @override
  Future<List<MeetingModel>> getCachedMeetingsOfTheMonth() async{
    throw UnimplementedError();


  }

  @override
  Future<List<MeetingModel>> getCachedMeetingsOfTheWeek()async {
    throw UnimplementedError();


  }

  @override
  Future<Unit> cacheNotes(List<NoteModel> notes,String start,String limit) async {
    await MeetingStore.cacheNotes(notes,start,limit);
    return Future.value(unit);


  }

  @override
  Future<List<NoteModel>> getNotes(String start,String limite) async{
    final notes=await MeetingStore.getNotes(start,limite);
    if (notes.isNotEmpty) {
      return notes;
    } else {
      return [];
    }

  }

  @override
  Future<Unit> saveExcelFile(Uint8List bytes, String filename) async {
    final directory = await getExternalStorageDirectory();
    final downloadsDir = Directory('/storage/emulated/0/Download'); // Default path for downloads on most Android devices

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

}