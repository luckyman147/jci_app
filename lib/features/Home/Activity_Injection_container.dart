import 'package:firebase_database/firebase_database.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jci_app/features/Home/data/datasources/Category/CategoryLocalDataSource.dart';
import 'package:jci_app/features/Home/data/datasources/Category/CategoryRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/datasources/PVs/PVLocalDataSources.dart';
import 'package:jci_app/features/Home/data/datasources/PVs/PVRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/datasources/Participants&Guest/Guest/GuestRemoteDataSources.dart';
import 'package:jci_app/features/Home/data/datasources/Participants&Guest/Particpant/PaticipantsRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/datasources/Polls/PollRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/datasources/notes/CommentLocalDataSources.dart';
import 'package:jci_app/features/Home/data/datasources/notes/CommentRemoteDataSources.dart';
import 'package:jci_app/features/Home/data/repositories/Catogory/CategoryRepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/PV/PVRepoImpl.dart';
import 'package:jci_app/features/Home/data/repositories/PollRepositoriesImpl/PollRepoImpl.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/entities/guest/Guest.dart';
import 'package:jci_app/features/Home/domain/repsotories/CategoriesRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/PVRepo.dart';
import 'package:jci_app/features/Home/domain/repsotories/PollRepositories.dart';
import 'package:jci_app/features/Home/domain/usercases/PvUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/guests/guests_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';

import '../../core/Handlers/Handler.dart';
import 'Activity_Global.dart';

import 'data/datasources/activities/ActivityRemote.dart';
import 'domain/entities/PVEntity/PV.dart';
import 'domain/entities/guest/ActivityGuest.dart';
import 'domain/entities/poll/Poll.dart';
import 'domain/repsotories/GuestRepsotories.dart';
import 'domain/usercases/CategoryUseCases.dart';
import 'domain/usercases/PollUsesCases.dart';
import 'presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';

final sl = GetIt.instance;

Future<void> initActivities() async {
  sl.registerFactory(() => ActivityCommentBloc(sl(), sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(
      () => PollBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory(() => AcivityFBloc(
        sl(),
        sl(),
        sl(),
        getEventsOfTheMonthUseCase: sl(),
        participantBloc: sl(),
        getAllActivitiesUseCases: sl(),
        getActivityByIdUseCases: sl(),
        getActivityByNameUseCases: sl(),
      ));
  sl.registerFactory(() => ParticpantsBloc(
        sl(),
        UpdateAbsenceUseCases: sl(),
        getAllParticipantsUseCases: sl(),
        sendReminderUseCases: sl(),
        getParticipantsOfActivityUseCases: sl(),
        updateMembersAttendanceUseCases: sl(),
      ));
  sl.registerFactory(
      () => GuestsBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => CalendarCubit());
  sl.registerFactory(() => PvBloc(sl(), sl(), sl(), sl()));

  sl.registerFactory(() => ActivityCubit());
  sl.registerFactory(() => TextFieldBloc());

  sl.registerFactory(() => AddDeleteUpdateBloc(
      checkPermissionsUseCase: sl(),
      updateActivityUseCases: sl(),
      createActivityUseCase: sl(),
      deleteActivityUseCases: sl()));
  sl.registerFactory(() => FormzBloc());

  sl.registerFactory(() => VisibleBloc());
  sl.registerFactory(
      () => CategoryBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  ///datasources

  sl.registerLazySingleton<TrainingLocalDataSource>(
      () => TrainingLocalDataSourceImpl(store: sl()));
  sl.registerLazySingleton<PvLocalDataSources>(
      () => PVLocalDataSourcesImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<PVremoteDataSource>(() =>
      PVRemoteDataSourceImpl(logger: sl(), firestore: sl(), storage: sl()));

  sl.registerLazySingleton<TrainingRemoteDataSource>(
      () => TrainingRemoteDataSourceImpl(sl(), sl(), sl(), sl(), client: sl()));
  sl.registerLazySingleton<EventRemoteDataSource>(() =>
      EventRemoteDataSourceImpl(sl(), sl(),
          firabaseFireStore: sl(), logger: sl()));
  sl.registerLazySingleton<MeetingRemoteDataSource>(
      () => MeetingRemoteDataSourceImpl(sl(), sl(), firabaseFireStore: sl()));
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<EventLocalDataSource>(
      () => EventLocalDataSourceImpl(sl(),store: sl()));
  sl.registerLazySingleton<GuestRemoteDataSources>(
      () => GuestRemoteDataSourcesImpl(firabaseFireStore: sl(), logger: sl()));
  sl.registerLazySingleton<CommentRemoteDataSources>(
      () => CommentRemoteDataSourcesImpl(sl(), sl(), databaseReference: sl()));
  sl.registerLazySingleton<CommentLocalDataSource>(
      () => CommentLocalDataSourceImpl());
  sl.registerLazySingleton<MeetingLocalDataSource>(
      () => MeetingLocalDataSourceImpl(sl(), meetingStore: sl()));
  sl.registerLazySingleton<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl());
  sl.registerLazySingleton<PollRemoteDataSource>(() => PollRemoteDataSourceImpl(
      databaseReference: sl(), logger: sl(), firestore: sl()));
  sl.registerLazySingleton<ParticipantsRemoteDataSource>(() =>
      ParticipantsRemoteDataSourceImpl(sl(),
          logger: sl(), firabaseFireStore: sl()));

//use cases
  sl.registerLazySingleton(() => AddReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentToActivityUseCase(sl()));
  sl.registerLazySingleton(() => SendCommentNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCommentToActivityUseCase(sl()));
  sl.registerLazySingleton(() => GetCommentsOfActivityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCommentToActivityUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReplyToCommentUseCase(sl()));
  sl.registerLazySingleton(() => AddReactionsToCommentUseCase(sl()));
  sl.registerLazySingleton(() => AddReactionsToReplyUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReactionsToCommentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateReactionsToReplyUseCase(sl()));
  sl.registerLazySingleton(
      () => CheckPermissionsUseCases(activitiesRepo: sl()));
//poll
  sl.registerLazySingleton(() => CreatePollUseCase(sl()));
  sl.registerLazySingleton(() => GetPollsOfActivityUseCase(sl()));
  sl.registerLazySingleton(() => AddOptionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOption(sl()));
  sl.registerLazySingleton(() => UpdateVote(sl()));
  sl.registerLazySingleton(() => DeletePollUseCase(sl()));

  ///PV
  sl.registerLazySingleton(() => AddPv(sl()));
  sl.registerLazySingleton(() => GetPvsOfActivty(sl()));
  sl.registerLazySingleton(() => DeletePv(sl()));
  sl.registerLazySingleton(() => DownloadPv(sl()));

  sl.registerLazySingleton(
      () => CheckAbsenceUseCases(participantsRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllParticipantsUseCases(participantsRepository: sl()));
  sl.registerLazySingleton(
      () => GetActivityByNameUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(
      () => ChangeGuestToMemberUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(
      () => AddGuestToActivityUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(
      () => GetAllActivitiesUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => SendReminderUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => GetGuestsUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => GetAllGuestsUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => AddGuestUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => DeleteGuestUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => UpdateGuestUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => ConfirmGuestUseCases(guestsRepository: sl()));
  sl.registerLazySingleton(() => DeleteActivityUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => UpdateActivityUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => CreateActivityUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => GetActivityByIdUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => LeaveActivityUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(
      () => ParticipateActivityUseCases(activitiesRepo: sl()));
  sl.registerLazySingleton(() => deleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => getAllCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => getCategoryByIdUseCase(sl()));
  sl.registerLazySingleton(() => getCategoryByName(sl()));
  sl.registerLazySingleton(() => updateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => createCategoryUseCase(sl()));
  sl.registerLazySingleton(() => fetchCategoriesByIdsUseCase(sl()));
  sl.registerLazySingleton(() => GetPollAsTemplatesUseCase(sl()));
  sl.registerLazySingleton(
      () => GetParticipantsOfActivityUseCases(participantsRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateMembersAttendanceUseCases(participantsRepository: sl()));

  // Repositories
  sl.registerLazySingleton<ActivitiesRepo>(() => ActivityRepoImpl(
      sl(), sl(), sl(), sl(),
      meetingLocalDataSource: sl(),
      eventLocalDataSource: sl(),
      meetingRemoteDataSource: sl(),
      trainingRemoteDataSource: sl(),
      eventRemoteDataSource: sl(),
      trainingLocalDataSource: sl(),
      Unithandler: sl()));
  sl.registerLazySingleton<GuestsRepository>(() => GuestRepoImpl(
      guestRemoteDataSources: sl(),
      unitHandler: sl(),
      actiguestHandler: sl(),
      actiguestsHandler: sl(),
      guestsHandler: sl()));

  sl.registerLazySingleton<ParticipantsRepository>(() => ParticipantsRepoImpl(
      participantsRemoteDataSource: sl(),
      handler: sl(),
      partHandler: sl(),
      DetailsHandler: sl()));
  sl.registerLazySingleton<PVrepo>(() => PvRepoImpl(
        remoteDataSource: sl(),
        localDataSources: sl(),
        unitHandler: sl(),
        listPVHandler: sl(),
      ));
  sl.registerLazySingleton<ActivityCommentRepo>(() => ActivityCommentRepoImpl(
      commentLocalDataSource: sl(),
      commentRemoteDataSource: sl(),
      unitHandler: sl(),
      commentHandler: sl()));
  sl.registerLazySingleton<PollRepository>(() => PollRepoImpl(
        sl(),
        pollRemoteDataSource: sl(),
        handler: sl(),
      ));

  sl.registerLazySingleton<CategoryRepo>(() => CategoryRepoImpl(
      sl(), sl(), sl(),
      categoryRemoteDataSource: sl(), categoryLocalDataSource: sl()));
  sl.registerFactory(() => FirebaseImageUploader());
  sl.registerFactory(() => MeetingStore());
  final eventStore = await EventStore.create();
  sl.registerSingleton<EventStore>(eventStore);
  sl.registerFactory(() => FirebaseDatabase.instance);
  sl.registerFactory(() => Handler<List<User>>(sl(), networkInfo: sl()));
  sl.registerFactory(
      () => Handler<List<ParticipantDetailsParam>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<List<PV>>(sl(), networkInfo: sl()));

  sl.registerFactory(
      () => Handler<List<ActivityComment>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<List<Poll>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<List<Guest>>(sl(), networkInfo: sl()));
  sl.registerFactory(
      () => Handler<List<ActivityGuest>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<ActivityGuest>(sl(), networkInfo: sl()));
  sl.registerFactory(() => ActivityRemoteDataSource(
        store: sl(),
      ));

  //datasources
  // Register http.Client first

  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}
