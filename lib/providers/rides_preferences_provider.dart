import 'package:bla_project_w7/model/ride/ride_pref.dart';
import 'package:bla_project_w7/repository/ride_preferences_repository.dart';
import 'package:flutter/material.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences when the provider is created
    _pastPreferences = repository.getPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) {
    // Process only if the new preference is not equal to the current one
    if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  void _addPreference(RidePreference preference) {
    // Check if the preference is not already in the list
      repository.addPreference(preference);
    
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory => _pastPreferences.reversed.toList();
}