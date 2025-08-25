import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';

import '../../../../../domain/entities/Activitys/Place.dart';
import '../../../../../domain/usercases/ActivityUseCases.dart';

part 'place__state.dart';

class PlaceCubit extends Cubit<PlaceState> {
 final  GetSuggestedPlaceDetailsUseCases getSuggestedPlaceDetailsUseCases;
 final  GetSuggestedPlacesUseCases getPlaceDetailsUseCases;
  PlaceCubit(this.getSuggestedPlaceDetailsUseCases, this.getPlaceDetailsUseCases) : super(PlaceInitial());
  Future<void> getSuggestedPlaces(String query) async {
    emit(state.copyWith(isLoading: true));
    try {
      final places = await getPlaceDetailsUseCases(query);
      places.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: mapFailureToMessage(failure),
        )),
        (placesList) => emit(state.copyWith(places: placesList)),
      );
    } catch (e) {
      emit(state.copyWith(
        places: [],
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      ));
    }
  }
  selectPlce(Place place) {
    emit(state.copyWith(place: place));
  }
  Future<void> getSuggestedPlaceDetails(Place placeId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final placeDetails = await getSuggestedPlaceDetailsUseCases(placeId);
      placeDetails.fold(
        (failure) => emit(state.copyWith(
          isLoading: false,
          errorMessage: mapFailureToMessage(failure),
        )),
        (place) => emit(state.copyWith(place: place)),
      );
    } catch (e) {
      emit(state.copyWith(
        place: null,
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      ));
    }
  }

}
