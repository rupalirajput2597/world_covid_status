import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import '/../core/core.dart';
import '../home.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState()) {}

  List<Country> countries = [];
  Map<String, dynamic> isoCodes = <String, dynamic>{};

  Country? currentCountry;

  fetCountries(context, {isRefreshing = true}) async {
    emit(HomeLoadingState());
    try {
      CountryList? countryList = await Api.fetchCountries();
      if (!isRefreshing) await getCurrentLocation(context);
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

  getCurrentLocation(BuildContext context) async {
    try {
      Placemark? place = await getCountry(context);
      if (place != null) {
        currentCountry = Country(name: place.country!);
        currentCountry?.isoCode = place.isoCountryCode?.toLowerCase();
        currentCountry?.flagUrl =
            "https://flagcdn.com/h40/${currentCountry?.isoCode}.png";
      } else {
        currentCountry = null;
      }
    } catch (e) {
      currentCountry = null;
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
          countries[i].isoCode = key;
          countries[i].flagUrl = "https://flagcdn.com/h40/$key.png";
        }
      }
    });
    countries.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    if (currentCountry != null) {
      countries.removeWhere((country) {
        return currentCountry?.isoCode == country.isoCode;
      });
      countries.insert(0, currentCountry!);
    }
  }
}
