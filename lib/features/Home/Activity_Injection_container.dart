
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/features/Home/data/datasources/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/events/event_remote_datasources.dart';
import 'package:jci_app/features/Home/data/repositories/EventRepoImpl.dart';
import 'package:jci_app/features/Home/domain/repsotories/EventRepo.dart';
import 'package:jci_app/features/Home/domain/usercases/EventUseCases.dart';
import 'package:jci_app/features/Home/presentation/bloc/Event/events_bloc.dart';



import '../../core/network/network_info.dart';

import 'package:http/http.dart' as http;



final sl = GetIt.instance;

Future <void > initActivities()async{
  sl.registerFactory(() => EventsBloc( getALlEventsUseCase: sl(), getEventsOfTheWeekUseCase: sl(), getEventsOfTheMonthUseCase: sl()));




  sl.registerLazySingleton<EventRemoteDataSource>(
          () => EventRemoteDataSourceImpl(

        client: sl(),
      ));
  sl.registerLazySingleton<EventLocalDataSource>(() => EventLocalDataSourceImpl());



//use cases
  sl.registerLazySingleton(() => GetALlEventsUseCase( eventRepository: sl()));
  sl.registerLazySingleton(() => GetEventsOfTheMonthUseCase(  eventRepository: sl()));
  sl.registerLazySingleton(() => GetEventsOfTheWeekUseCase(  eventRepository: sl()));


  // Repositories

  sl.registerLazySingleton<EventRepo>(() => EventRepoImpl(eventRemoteDataSource: sl(),
      eventLocalDataSource: sl(), networkInfo: sl()));

  //datasources
  // Register http.Client first



  // Register other dependencies
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}