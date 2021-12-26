# Weather App
Weather app uses Open Weather Map to fetch information about weather in cities.

# Table of contents
1. [Demo](#demo)
2. [Implementation](#implementation)
3. [Assumptions](#assumptions)
4. [Aspects to Fix/Improve](#aspects)
5. [Todos](#todos)

## Demo <a name="demo"></a>
<p align="center">
  <img width="30%" src="https://s10.gifyu.com/images/weatherApp.gif">
</p>

## Implementation <a name="implementation"></a>

✅ Layered Architecture  
✅ Dependency inversion - kept inner layers independent  
✅ Bloc used for State Management    <img src="https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/flutter_bloc_logo_full.png" height="20" alt="Flutter Bloc Package" />  
✅ Unit tests  
✅ Retrofit used to generate HTTP requests  
✅ Injectable and GetIt packages used for Dependency Injection.  

## Assumptions <a name="assumptions"></a>
✅ City is only valid if Open Weather API returns valid response containing valid weather data  
✅ Persistance Storage - data is saved to the memory immediately a user adds or modifies entries.

## Aspects to Fix/Improve <a name="aspects"></a>
❗️ Single Source of Truth Rule is broken - CitiesOverviewBloc and SharedPrefereces keep data and they can be modified separately. There should be a single place to modify data - CitiesOverviewBloc and SharedPreferenced should only reflect changes to it.  
❗️ Having City validated by Open Weather API has many negative implications: added boilerplate code and made code more complicated. Another way of validating city could be considered.  
❗️ Shared Preferences were used for the simplicity. Consider replacing with local database.

## Todos <a name="todos"></a>
- [ ] Add bloc unit tests
- [ ] Add Widget tests
- [ ] Add Intergration tests