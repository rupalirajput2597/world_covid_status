import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/core.dart';
import 'covid_detail_state.dart';

class CovidDetailCubit extends Cubit<CovidDetailState> {
  CovidDetailCubit() : super(CovidDetailInitialState());
  CovidStatResponse? covidStat;

  fetchCovidDetailForCountry(Country selectedCountry) async {
    emit(CovidDetailLoadingState());
    try {
      covidStat = await Api.fetchCountryCovidDetails(selectedCountry.name);
      if (covidStat != null) {
        emit(CovidDetailFetchedState());
      }
    } on SocketException catch (e, s) {
      emit(CovidDetailsErrorState(900));
    } catch (e) {
      emit(CovidDetailsErrorState(100));
    }
  }
}
