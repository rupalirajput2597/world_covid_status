import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/../core/core.dart';
import '../home.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState()) {}

  List<Country> countries = [];
  Map<String, dynamic> isoCodes = <String, dynamic>{};

  Country? currentCountry;

  fetCountries() async {
    emit(HomeLoadingState());
    try {
      CountryList? countryList = await Api.fetchCountries();
      var isoResponse = await Api.fetchIsoCode();
      if ((countryList != null) && (isoResponse != null)) {
        countries = countryList.countryList ?? [];
        isoCodes = isoResponse;
      } else {
        emit(HomeErrorState(100));
      }

      _mapIsoCodeToCountry();
      emit(CountriesFetchSuccessfulState());
    } on SocketException catch (e, s) {
      emit(HomeErrorState(900));
    } catch (e) {
      emit(HomeErrorState(100));
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
          countries[i].isoCode = key;
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

    countries.remove(currentCountry);
    countries.insert(0, currentCountry!);
  }
}
