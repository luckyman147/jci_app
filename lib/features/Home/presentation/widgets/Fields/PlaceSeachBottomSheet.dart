import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Places/place__cubit.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../domain/entities/Activitys/Place.dart';
import '../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';

import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
class PlaceSearchBottomSheet extends StatefulWidget {
  final String apiKey;

  const PlaceSearchBottomSheet({super.key, required this.apiKey});
static void openPlaceSearch(BuildContext context, String apiKey) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => PlaceSearchBottomSheet(apiKey: apiKey),
  );
}

  @override
  State<PlaceSearchBottomSheet> createState() => _PlaceSearchBottomSheetState();
}

  class _PlaceSearchBottomSheetState extends State<PlaceSearchBottomSheet> {
    final TextEditingController _controller = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.all(12),

            child:

                GooglePlaceAutoCompleteTextField(
                  textEditingController: _controller,
                  googleAPIKey: Constants.API_KEY, // <-- your env or constants
                  debounceTime: 800,
                  isLatLngRequired: true,


                  // When lat/lng is required and available
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    debugPrint("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
                    final place = Place(
                      name: prediction.description ?? "",
                      address: prediction.structuredFormatting?.secondaryText ?? "",
                      lat: double.parse( prediction.lat!) ?? 0.0,
                      lng: double.parse( prediction.lng!)  ?? 0.0,
                      placeId: prediction.placeId ?? "",
                    );
                    context.read<PlaceCubit>().selectPlce(place);
                    Navigator.pop(context); // close after selection
                  },

                  // Handle item click
                  itemClick: (Prediction prediction) {
                    _controller.text = prediction.description ?? "";
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0),
                    );
                  },

                  // Custom list item builder
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                           Icon(Icons.location_on, color: ColorsApp.PrimaryColor),
                          const SizedBox(width: 7),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prediction.structuredFormatting?.mainText ?? "",
                                    style: PoppinsRegular(16, ColorsApp.textColorBlack)),
                                const SizedBox(height: 2),
                                Text(prediction.structuredFormatting?.secondaryText ?? "",
                                    style: PoppinsRegular(13, ColorsApp.textColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },

                  seperatedBuilder: const Divider(height: 1),
                  isCrossBtnShown: true,
                  containerHorizontalPadding: 10,
                  placeType: PlaceType.geocode,
                ),
          );

        },
      );
    }
  }
