import 'package:bla_project_w7/ui/providers/asyncValue.dart';
import 'package:bla_project_w7/ui/providers/rides_preferences_provider.dart';
import 'package:bla_project_w7/ui/widgets/error/bla_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // Use the provider to set the current preference
    Provider.of<RidesPreferencesProvider>(context, listen: false)
        .setCurrentPreferrence(newPreference);

    // Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ridesPrefsProvider = Provider.of<RidesPreferencesProvider>(context);
    final currentRidePreference = ridesPrefsProvider.currentPreference;
    // final pastPreferences = ridesPrefsProvider.preferencesHistory;

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                      initialPreference: currentRidePreference,
                      onSubmit: (pref) => onRidePrefSelected(context, pref)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  
                  SizedBox(
                    height: 200,
                    child: _buildPreferencesList(ridesPrefsProvider),
                  )
                  
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferencesList(RidesPreferencesProvider ridesPrefsProvider) {
    final pastPrefs = ridesPrefsProvider.pastPreferences;

    switch (pastPrefs.state) {
      case AsyncValueState.loading:
        return const Center(
            child: CircularProgressIndicator()); // display a progress

      case AsyncValueState.error:
        return Center(
          child: const BlaError(
              message: 'No connection. Try later'),
        ); // display an error

      case AsyncValueState.success:
        if (pastPrefs.data == null) {
          return const Center(
              child: Text('No past preference yet!')); // display an empty state
        }
        return ListView.builder(
          shrinkWrap: true, // Fix ListView height issue
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: ridesPrefsProvider.preferencesHistory.length,
          itemBuilder: (ctx, index) => RidePrefHistoryTile(
            ridePref: ridesPrefsProvider.preferencesHistory[index],
            onPressed: () => onRidePrefSelected(
                ctx, ridesPrefsProvider.preferencesHistory[index]),
          ),
        );
    }
  }

}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
