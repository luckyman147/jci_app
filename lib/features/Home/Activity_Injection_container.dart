
import 'package:get_it/get_it.dart';

import 'package:jci_app/features/Home/data/datasources/Meetings/MeetingLocaldatasources.dart';
import 'package:jci_app/features/Home/data/datasources/Meetings/Meeting_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/event_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/trainings/TrainingLocalDatasources.dart';
import 'package:jci_app/features/Home/data/datasources/trainings/Training_Remote_datasources.dart';
import 'package:jci_app/features/Home/data/repositories/MeetingRepoImpl/MeetingrepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/TrainingRepoImpl/TrainingRepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/events/EventRepoImpl.dart';
import 'package:jci_app/features/Home/domain/repsotories/EventRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/TrainingRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/meetingRepo.dart';
import 'package:jci_app/features/Home/domain/usercases/EventUseCases.dart';
import 'package:jci_app/features/Home/domain/usercases/TrainingUseCase.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';


import 'domain/usercases/MeetingsUseCase.dart';



final sl = GetIt.instance;

Future <void > initActivities()async{

  sl.registerFactory(()=> AcivityFBloc(getTrainingsOfTheMonthUseCase: sl(), getALlTrainingsUseCase: sl(),
      getEventsOfTheMonthUseCase: sl(), getALlEventsUseCase: sl(), getALlMeetingsUseCase: sl(), getEventByIdUseCase: sl(), getTrainingByIdUseCase: sl(), getMeetingByIdUseCase: sl()));

sl.registerFactory(() => ActivityOfweekBloc( getEventsOfTheWeekUseCase: sl(), getMeetingsOfTheWeek: sl(), getTrainingsOfTheWeek: sl()));
  sl.registerFactory(() =>ActivityCubit());




//datasources

  sl.registerLazySingleton<TrainingLocalDataSource>(()=>TrainingLocalDataSourceImpl());
  sl.registerLazySingleton<TrainingRemoteDataSource>(()=>TrainingRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<EventRemoteDataSource>(
          () => EventRemoteDataSourceImpl(
        client: sl(),
      )); sl.registerLazySingleton<MeetingRemoteDataSource>(
          () => MeetingRemoteDataSourceImpl(

        client: sl(),
      ));
  sl.registerLazySingleton<EventLocalDataSource>(() => EventLocalDataSourceImpl());
  sl.registerLazySingleton<MeetingLocalDataSource>(() => MeetingLocalDataSourceImpl());



//use cases

  sl.registerLazySingleton(() => GetTrainingByIdUseCase(    TrainingRepository: sl()));
  sl.registerLazySingleton(() => GetMeetingByIdUseCase(   MeetingRepository: sl()));
  sl.registerLazySingleton(() => GetEventByIdUseCase(   eventRepository: sl()));
  sl.registerLazySingleton(() => GetTrainingsOfTheWeekUseCase(   TrainingRepository: sl()));
  sl.registerLazySingleton(() => GetTrainingsOfTheMonthUseCase(   TrainingRepository: sl()));
  sl.registerLazySingleton(() => GetALlTrainingsUseCase(   TrainingRepository: sl()));

  sl.registerLazySingleton(() => GetALlMeetingsUseCase( MeetingRepository: sl()));
  sl.registerLazySingleton(() => GetMeetingsOfTheWeekUseCase(  MeetingRepository: sl()));
  sl.registerLazySingleton(() => GetALlEventsUseCase( eventRepository: sl()));
  sl.registerLazySingleton(() => GetEventsOfTheMonthUseCase(  eventRepository: sl()));
  sl.registerLazySingleton(() => GetEventsOfTheWeekUseCase(  eventRepository: sl()));


  // Repositories

  sl.registerLazySingleton<EventRepo>(() => EventRepoImpl(eventRemoteDataSource: sl(),
      eventLocalDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<MeetingRepo>(() => MeetingRepoImpl(meetingRemoteDataSource: sl(), meetingLocalDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<TrainingRepo>(() => TrainingRepoImpl( networkInfo: sl(), trainingRemoteDataSource: sl(), trainingLocalDataSource: sl()));


  //datasources
  // Register http.Client first





  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}