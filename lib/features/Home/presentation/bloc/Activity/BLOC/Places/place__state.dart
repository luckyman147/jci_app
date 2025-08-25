part of 'place__cubit.dart';

 class PlaceState extends Equatable {
  const PlaceState({
    this.suggestedPlaces = const [],
    this.place,
    this.errorMessage = "",
    this.isLoading = false,

 });
  final bool isLoading ;
  final List<Place> suggestedPlaces ;
final Place? place  ;
final String errorMessage ;
  PlaceState copyWith({
    List<Place>? places,
    Place? place,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlaceState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      suggestedPlaces: places ?? suggestedPlaces,
      place: place ?? this.place,
    );
  }
  @override
  // TODO: implement props
  List<Object?> get props => [suggestedPlaces,isLoading,errorMessage,place];
}

final class PlaceInitial extends PlaceState {
  @override
  List<Object> get props => [];
}
