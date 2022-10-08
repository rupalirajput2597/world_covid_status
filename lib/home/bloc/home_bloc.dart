import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/core/constants.dart';
import 'package:world_covid_status/core/core.dart';

import '../../core/models/country_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeEvent>(mapEventToState);
  }

  List<Country> countries = [];
  Map<String, dynamic> isoCodes = <String, dynamic>{};

  Country? currentCountry;

  void mapEventToState(HomeEvent event, Emitter<HomeState> emit) async {
    if (event is HomeInitialEvent) {
      emit(HomeLoadingState());
      try {
        CountryList l = await Api.fetchCountries();

        // var a = await getCountryName();
        isoCodes = Constants.countriesCode; //await Api.fetchIsoCode();
        countries = l.countriesNew ?? [];
        // Constants.countriesL.forEach((element) {
        //   //var a = element.toString().trim().replaceAll("-", " ");
        //   countries.add(Country(name: element));
        // });
        print("here ---  ${countries.length}");
        print("here ---  ${isoCodes.length}");

        mapIsoCodeToCountry();
        emit(CountriesFetchSuccessfulState());
      } catch (e) {
        print(e.toString());
      }
    }

    if (event is HomeRefreshEvent) {
      emit(HomeRefreshState());
    }
  }

  mapIsoCodeToCountry() {
    isoCodes.forEach((key, value) {
      for (int i = 0; i < countries.length; ++i) {
        var a = countries[i]
            .name
            .toString()
            .trim()
            .replaceAll(RegExp('[^A-Za-z0-9]'), '');
        var b = value.toString().trim().replaceAll(RegExp('[^A-Za-z0-9]'), '');

        //  print("$b == $a");
        if (a == b) {
          countries[i].flagUrl = "https://flagcdn.com/h40/$key.png";
          if (key == "in") {
            currentCountry = countries[i];
          }
        }
      }
    });
    countries.sort((a, b) {
      return a.name.compareTo(b.name);
    });
  }
}
