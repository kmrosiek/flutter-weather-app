# Weather App
Weather app uses Open Weather Map to fetch information about weather in cities.

## Demo
<p align="center">
  <img width="30%" src="https://s10.gifyu.com/images/weatherApp.gif">
</p>

## Implementation

✅ Layered Architecture
✅ Dependency inversion - kept inner layers independent
✅ Bloc used for State Management <img src="https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/flutter_bloc_logo_full.png" height="20" alt="Flutter Bloc Package" />
✅ Unit tests
✅ Retrofit used to generate HTTP requests
✅ Injectable and GetIt packages used for Dependency Injection.

## Assumptions
✅ City is only valid if Open Weather API returns valid response containing valid weather data
✅ Persistance Storage - data is saved to the memory immediately a user adds or modifies entries.

## Aspects to fix or to improve 
❗️ Single Source of Truth Rule is broken - CitiesOverviewBloc and SharedPrefereces keep data and they can be modified separately. There should be a single place to modify data - CitiesOverviewBloc and SharedPreferenced should only reflect changes to it.
❗️ Having City validated by Open Weather API has many negative implications: added boilerplate code and made code more complicated. Another way of validating city could be considered.
❗️ Shared Preferences were used for the simplicity. Consider replacing with local database.

## Todos
- [ ] Add bloc unit tests
- [ ] Add Widget tests
- [ ] Add Intergration tests