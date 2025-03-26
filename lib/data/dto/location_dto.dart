import 'package:bla_project_w7/model/location/locations.dart';

class LocationDto {
  static Map<String, dynamic> toJson(Location model) {
    return {
      'name': model.name,
      'country': model.country.name,
    };
  }
  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      country: countryFromJson(json['country']),
    );
  }
  static Country countryFromJson(String value) {
    return Country.values.firstWhere((e) => e.name == value,
        orElse: () => throw Exception('Invalid country: $value'));
  }
}
