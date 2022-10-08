/*import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/core.dart';
import 'bloc.dart';

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
        isoCodes = await Api.fetchIsoCode();
        countries = l.countriesNew ?? [];
        // Constants.countriesL.forEach((element) {
        //   //var a = element.toString().trim().replaceAll("-", " ");
        //   countries.add(Country(name: element));
        // });
        print("here ---  ${countries.length}");
        print("here ---  ${isoCodes.length}");

        _mapIsoCodeToCountry();
        emit(CountriesFetchSuccessfulState());
      } catch (e) {
        print(e.toString());
      }
    }

    if (event is HomeRefreshEvent) {
      emit(HomeRefreshState());
    }
  }

  _mapIsoCodeToCountry() {
    isoCodes.forEach((key, value) {
      for (int i = 0; i < countries.length; ++i) {
        var a = countries[i]
            .name
            .toString()
            .trim()
            .replaceAll(RegExp('[^A-Za-z0-9]'), '');
        var b = value.toString().trim().replaceAll(RegExp('[^A-Za-z0-9]'), '');
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
}*/

import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/core.dart';
import 'bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState()) {}

  List<Country> countries = [];
  Map<String, dynamic> isoCodes = <String, dynamic>{};

  Country? currentCountry;

  fetCountries() async {
    emit(HomeLoadingState());
    try {
      CountryList l = await Api.fetchCountries();
      isoCodes = await Api.fetchIsoCode();
      countries = l.countriesNew ?? [];
      // Constants.countriesL.forEach((element) {
      //   //var a = element.toString().trim().replaceAll("-", " ");
      //   countries.add(Country(name: element));
      // });
      print("here ---  ${countries.length}");
      print("here ---  ${isoCodes.length}");

      _mapIsoCodeToCountry();
      emit(CountriesFetchSuccessfulState());
    } catch (e) {
      print(e.toString());
    }
  }

  refreshScreen() {
    emit(HomeRefreshState());
  }

  _mapIsoCodeToCountry() {
    isoCodes.forEach((key, value) {
      for (int i = 0; i < countries.length; ++i) {
        var a = countries[i]
            .name
            .toString()
            .trim()
            .replaceAll(RegExp('[^A-Za-z0-9]'), '');
        var b = value.toString().trim().replaceAll(RegExp('[^A-Za-z0-9]'), '');
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
