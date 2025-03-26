import 'package:bla_project_w7/data/dto/location_dto.dart';
import 'package:bla_project_w7/model/ride/ride_pref.dart';

class RidePreferenceDto {
  static Map<String, dynamic> toJson(RidePreference model) {
    return {
    'departure': LocationDto.toJson(model.departure),
    'departureDate': model.departureDate.toIso8601String(),
    'arrival': LocationDto.toJson(model.arrival),
    'requestedSeats': model.requestedSeats,
  };
  }

  static RidePreference fromJson(Map<String, dynamic> json) {
    return RidePreference(
      departure: LocationDto.fromJson(json['departure']),
      departureDate: DateTime.parse(json['departureDate']),
      arrival: LocationDto.fromJson(json['arrival']),
      requestedSeats: json['requestedSeats'],
      // Initialize other fields as needed
    );
  }
}

