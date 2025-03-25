import 'package:bla_project_w7/ui/providers/rides_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // 1 - Back to the previous view
    Navigator.of(context).pop();
  }

  onRidePrefSelected(RidePreference newPreference) async {}

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    var rideProvider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference
      rideProvider.setCurrentPreferrence(newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when it changes
    final ridesPrefsProvider = Provider.of<RidesPreferencesProvider>(context);
    final currentPreference = ridesPrefsProvider.currentPreference;

    // Ensure we have a current preference
    if (currentPreference == null) {
      return const Scaffold(
        body: Center(
          child: Text("No ride preference selected"),
        ),
      );
    }

    final RideFilter currentFilter = RideFilter();
    final List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentPreference, currentFilter);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
