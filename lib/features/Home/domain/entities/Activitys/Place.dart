class Place {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String placeId;

  Place({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.placeId,
  });
// copy with
  Place copyWith({
    String? name,
    String? address,
    double? lat,
    double? lng,
    String? placeId,
  }) {
    return Place(
      name: name ?? this.name,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      placeId: placeId ?? this.placeId,
    );
  }

  static final  jciHammamSousse = Place(
    name: "Locale JCI Hammam Sousse",
    address: "Hammam Sousse, Tunisia",
    lat: 35.8596,   // Latitude
    lng: 10.5937,   // Longitude
    placeId: "ChIJW87sVUMi_RIRICud9HojrkU", // Google Place ID
  );

  // ✅ fixed fromJson
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? jciHammamSousse.name,
      address: json['address'] ?? jciHammamSousse.address,
      lat: (json['lat'] != null) ? json['lat'].toDouble() : jciHammamSousse.lat,
      lng: (json['lng'] != null) ? json['lng'].toDouble() : jciHammamSousse.lng,
      placeId: json['placeId'] ?? jciHammamSousse.placeId,
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'placeId': placeId,
    };




  }
  @override
  String toString() =>
      "Place(name: $name, address: $address, lat: $lat, lng: $lng)";

  static Place empty() {

    return jciHammamSousse;
  }
}