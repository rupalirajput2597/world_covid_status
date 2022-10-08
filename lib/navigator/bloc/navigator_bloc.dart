import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/navigator/bloc/navigator_event.dart';

import '../../covid_details/covid_details_screen.dart';
import '../../covid_details/cubit/covin_detail_cubit.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  late final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({required this.navigatorKey}) : super(0) {
    on<NavigatorEvent>(mapEventToState);
  }

  void mapEventToState(NavigatorEvent event, Emitter<dynamic> emit) async {
    if (event is NavigateToCovidDetailScreen) {
      _pushNewRoute(
          navigatorKey,
          BlocProvider<CovidDetailCubit>(
            create: (_) => CovidDetailCubit(),
            child: CovidStatisticsScreen(
              selectedCountry: event.country,
            ),
          ),
          "Covid detailed Screen");
    }

    if (event is NavigatorActionPop) {
      if (event.result != null) {
        navigatorKey.currentState?.pop(event.result);
      } else {
        navigatorKey.currentState?.pop();
      }
    }
  }

  _pushNewRoute(GlobalKey<NavigatorState> navigatorKey, Widget w, String name) {
    _pushNew(navigatorKey, widget: w, name: name);
  }

  Future<dynamic> _pushNew(
    GlobalKey<NavigatorState> navigatorKey, {
    required Widget widget,
    required String name,
    bool fullscreenDialog = false,
  }) async {
    return await navigatorKey.currentState?.push(
      MaterialPageRoute(
        fullscreenDialog: fullscreenDialog,
        builder: (context) => widget,
        settings: RouteSettings(name: name),
      ),
    );
  }
}
