import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/core/models/covid_stat_response_model.dart';

import '../../core/core.dart';
import 'covid_detail_state.dart';

class CovidDetailCubit extends Cubit<CovidDetailState> {
  CovidDetailCubit() : super(CovidDetailInitialState());
  CovidStatResponse? covidStat;

  fetchCovidDetailForCountry(Country selectedCountry) async {
    emit(CovidDetailLoadingState());
    try {
      //covidStat = await Api.fetchCountryCovidDetails(selectedCountry.name);

      if (covidStat != null) {
        print(covidStat?.toJson().toString());
        emit(CovidDetailFetchedState());
      }

      //print("****   $a");
    } catch (e) {
      print(e.toString());
    }
  }
}
