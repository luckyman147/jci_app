import 'package:dartz/dartz.dart';

import '../../../../../core/config/services/MeetingStore.dart';
import '../../../../../core/error/Exception.dart';
import '../../model/meetingModel/MeetingModel.dart';

abstract class MeetingLocalDataSource {
  Future<List<MeetingModel>> getAllCachedMeetings();
  Future<MeetingModel> getCachedMeetingById(String id);
  Future<List<MeetingModel>> getCachedMeetingsOfTheWeek();
  Future<List<MeetingModel>> getCachedMeetingsOfTheMonth();

  Future<Unit> cacheMeetings(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheWeek(List<MeetingModel> Meeting);
  Future<Unit> cacheMeetingsOfTheMonth(List<MeetingModel> Meeting);


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
}