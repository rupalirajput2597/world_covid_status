abstract class CovidDetailState {}

class CovidDetailInitialState extends CovidDetailState {}

class CovidDetailLoadingState extends CovidDetailState {}

class CovidDetailFetchedState extends CovidDetailState {}

class CovidDetailsErrorState extends CovidDetailState {
  final int statusCode;
  CovidDetailsErrorState(this.statusCode);
}
