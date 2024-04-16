import 'package:get_it/get_it.dart';

import 'package:jci_app/features/Home/data/datasources/Meetings/MeetingLocaldatasources.dart';
import 'package:jci_app/features/Home/data/datasources/Meetings/Meeting_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/event_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/trainings/TrainingLocalDatasources.dart';
import 'package:jci_app/features/Home/data/datasources/trainings/Training_Remote_datasources.dart';
import 'package:jci_app/features/Home/data/repositories/ActrivitiesRepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/MeetingRepoImpl/MeetingrepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/TrainingRepoImpl/TrainingRepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/events/EventRepoImpl.dart';
import 'package:jci_app/features/Home/domain/repsotories/ActivitiesRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/EventRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/TrainingRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/meetingRepo.dart';
import 'package:jci_app/features/Home/domain/usercases/EventUseCases.dart';
import 'package:jci_app/features/Home/domain/usercases/TrainingUseCase.dart';
//import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';

import 'domain/usercases/ActivityUseCases.dart';
import 'domain/usercases/MeetingsUseCase.dart';

final sl = GetIt.instance;

Future<void> initActivities() async {
  sl.registerFactory(() => AcivityFBloc(
    getTrainingsOfTheMonthUseCase: sl(),

    getEventsOfTheMonthUseCase: sl(),

 participantBloc: sl(), getAllActivitiesUseCases: sl(), getActivityByIdUseCases: sl(), ));
  sl.registerFactory(() => ParticpantsBloc(leaveActivityUseCases: sl(), participateActivityUseCases: sl()));



  sl.registerFactory(() => ActivityCubit());
  sl.registerFactory(() => TextFieldBloc());

  sl.registerFactory(() => AddDeleteUpdateBloc( checkPermissionsUseCase: sl(), checkTrainingPermissionsUseCase: sl(), checkMeetingPermissionsUseCase: sl(), updateActivityUseCases: sl(), createActivityUseCase: sl(), deleteActivityUseCases: sl()));
  sl.registerFactory(() => FormzBloc());

  sl.registerFactory(() => VisibleBloc());

//datasources

  sl.registerLazySingleton<TrainingLocalDataSource>(
      () => TrainingLocalDataSourceImpl());
  sl.registerLazySingleton<TrainingRemoteDataSource>(
      () => TrainingRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<EventRemoteDataSource>(
      () => EventRemoteDataSourceImpl(
            client: sl(),
          ));
  sl.registerLazySingleton<MeetingRemoteDataSource>(
      () => MeetingRemoteDataSourceImpl(
            client: sl(),
          ));
  sl.registerLazySingleton<EventLocalDataSource>(
      () => EventLocalDataSourceImpl());
  sl.registerLazySingleton<MeetingLocalDataSource>(
      () => MeetingLocalDataSourceImpl());

//use cases

sl.registerLazySingleton(() => LeaveEventUseCase(sl()));
sl.registerLazySingleton(() => CheckPermissionsUseCase(sl()));
sl.registerLazySingleton(() => CheckTrainingPermissionsUseCase(sl()));
sl.registerLazySingleton(() => CheckMeetPermissionsUseCase(sl()));


sl.registerLazySingleton(() => LeaveMeetingUseCase(sl()));
sl.registerLazySingleton(() => LeaveTrainingUseCase(sl()));
sl.registerLazySingleton(() => ParticipateEventUseCase(sl()));
sl.registerLazySingleton(() => ParticipateMeetingUseCase(sl()));
sl.registerLazySingleton(() => ParticipateTrainingUseCase(sl()));




  sl.registerLazySingleton(
      () => GetTrainingsOfTheWeekUseCase(TrainingRepository: sl()));
  sl.registerLazySingleton(
      () => GetTrainingsOfTheMonthUseCase(TrainingRepository: sl()));

  sl.registerLazySingleton(() => GetAllActivitiesUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => DeleteActivityUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => UpdateActivityUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => CreateActivityUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => GetActivityByIdUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => LeaveActivityUseCases( activitiesRepo: sl()));
  sl.registerLazySingleton(() => ParticipateActivityUseCases( activitiesRepo: sl()));

  sl.registerLazySingleton(
      () => GetMeetingsOfTheWeekUseCase(MeetingRepository: sl()));

  sl.registerLazySingleton(
      () => GetEventsOfTheMonthUseCase(eventRepository: sl()));
  sl.registerLazySingleton(
      () => GetEventsOfTheWeekUseCase(eventRepository: sl()));

  // Repositories

  sl.registerLazySingleton<EventRepo>(() => EventRepoImpl(
      eventRemoteDataSource: sl(),
      eventLocalDataSource: sl(),
      networkInfo: sl()));
  sl.registerLazySingleton<MeetingRepo>(() => MeetingRepoImpl(
      meetingRemoteDataSource: sl(),
      meetingLocalDataSource: sl(),
      networkInfo: sl()));
   sl.registerLazySingleton<ActivitiesRepo>(() => ActivityRepoImpl(

      meetingLocalDataSource: sl(),
      networkInfo: sl(), eventLocalDataSource: sl(), meetingRemoteDataSource: sl(), trainingRemoteDataSource: sl(), eventRemoteDataSource: sl(), trainingLocalDataSource: sl()));


  sl.registerLazySingleton<TrainingRepo>(() => TrainingRepoImpl(
      networkInfo: sl(),
      trainingRemoteDataSource: sl(),
      trainingLocalDataSource: sl()));

  //datasources
  // Register http.Client first

  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}
