import 'dart:convert';

import 'package:bla_project_w7/data/dto/ride_preference_dto.dart';
import 'package:bla_project_w7/data/repository/ride_preferences_repository.dart';
import 'package:bla_project_w7/model/ride/ride_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRidePreferencesRepository extends RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    
    // Get the string list from the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];
    
    // Convert the string list to a list of RidePreferences
    return prefsList.map((json) => 
      RidePreferenceDto.fromJson(jsonDecode(json))
    ).toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    // Get current preferences
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing preferences
    final List<RidePreference> preferences = await getPastPreferences();
    
    // Check if the preference is already in the list then add new prefs
     if (!preferences.contains(preference)) {
       preferences.add(preference);

      // Save the new list as a string list
      await prefs.setStringList(
        _preferencesKey,
        preferences.map((pref) => 
          jsonEncode(RidePreferenceDto.toJson(pref))
        ).toList(),
      );
    }
  }
}

   