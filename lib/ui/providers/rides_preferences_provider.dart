import 'package:bla_project_w7/model/ride/ride_pref.dart';
import 'package:bla_project_w7/repository/ride_preferences_repository.dart';
import 'package:bla_project_w7/ui/providers/asyncValue.dart';
import 'package:flutter/material.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;

  RidesPreferencesProvider({required this.repository}) {
    // Fetch past preferences when the provider is created
    pastPreferences = AsyncValue.loading();
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreferrence(RidePreference pref) async{
    // Process only if the new preference is not equal to the current one
    if (_currentPreference != pref) {
      _currentPreference = pref;
      await _addPreference(pref);
      notifyListeners();
    }
  }
  Future<void> fetchPastPreferences() async {
    // 1- Handle loading
    pastPreferences = AsyncValue.loading();
    notifyListeners();
    try {
      // 2 Fetch data
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      
      // 3 Handle success
      pastPreferences = AsyncValue.success(pastPrefs);
      notifyListeners();
    } catch (error) {
      // 4 Handle error
      pastPreferences = AsyncValue.error(error);
    }
    notifyListeners();
  }

  Future<void> _addPreference(RidePreference preference) async{
    // Check if the preference is not already in the list
      await repository.addPreference(preference);
      await fetchPastPreferences();
  }

  // History is returned from newest to oldest preference
  List<RidePreference> get preferencesHistory => pastPreferences.data!.reversed.toList();
}