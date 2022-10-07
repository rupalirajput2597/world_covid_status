import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/navigator/bloc/navigator_event.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  late final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({required this.navigatorKey}) : super(0) {
    on<NavigatorEvent>(mapEventToState);
  }

  void mapEventToState(NavigatorEvent event, Emitter<dynamic> emit) async {
    if (event is NavigateToHome) {}
  }
}
