import '../../core/core.dart';

abstract class NavigatorEvent {}

class NavigateToCovidDetailScreen extends NavigatorEvent {
  final Country country;
  NavigateToCovidDetailScreen(this.country);
}

class NavigatorActionPop extends NavigatorEvent {
  final dynamic result;

  NavigatorActionPop({this.result});
}
