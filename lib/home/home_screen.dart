import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/core/core.dart';

import '../navigator/navigator.dart';
import 'home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //variable declaration
  late final HomeCubit _cubit;
  late final TextEditingController searchController;
  List<Country> filteredCountries = [];

  //initializing
  @override
  void initState() {
    _cubit = context.read<HomeCubit>();
    searchController = TextEditingController();
    filteredCountries = [];
    _fetchCountries();
    super.initState();
  }

  //disposing
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetHelper.app_logo,
              width: 20,
              height: 20,
            ),
          ),
          title: const Text(
            "Covid-19 Statistics",
            style: TextStyle(color: Colors.pink),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
            if (state is CountriesFetchSuccessfulState) {
              filteredCountries = List.from(_cubit.countries);
            }

            if (state is HomeErrorState) {
              return _errorWidget(state);
            }

            return (state is HomeLoadingState)
                ? const HomeShimmer()
                : _content();
          }),
        ));
  }

  //main body
  Widget _content() {
    return Column(
      children: [_searchFieldWidget(), _listOfCountries()],
    );
  }

  //search field
  _searchFieldWidget() {
    return Card(
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextField(
        controller: searchController,
        onChanged: (a) {
          _searchCountriesFunction(a);
        },
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
            gapPadding: 0,
          ),
          contentPadding: const EdgeInsets.all(0),
          labelText: "Search",
          labelStyle: Theme.of(context).textTheme.bodyText1,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchController.text.isEmpty
              ? null
              : GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    _clearSearchBar();
                  },
                ),
        ),
      ),
    );
  }

//clearing search text
  void _clearSearchBar() {
    if (searchController.text.isNotEmpty) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).focusedChild?.unfocus();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => searchController.clear());
      filteredCountries = List.from(_cubit.countries);
      searchController.clear();

      _cubit.refreshScreen();

      return;
    }
  }

  //building UI for list of contries
  Widget _listOfCountries() {
    String oldAlphabet = "*";
    String newAlphabet = "*";

    return Expanded(
        child: filteredCountries.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(8),
                children: (0.to(filteredCountries.length - 1).map((index) {
                  oldAlphabet = newAlphabet;
                  newAlphabet =
                      filteredCountries[index].name.trim()[0].toUpperCase();

                  //reseting aphabets
                  if (index == filteredCountries.length - 1) {
                    oldAlphabet = "*";
                    newAlphabet = "*";
                  }

                  return index == 0
                      ? _countryListTile(
                          filteredCountries[index],
                          searchController.text.isEmpty,
                          "Current Location") //current contry Tile
                      : _countryListTile(
                          filteredCountries[index],
                          (oldAlphabet != newAlphabet),
                          newAlphabet); //other Countries
                }).toList()),
              )
            : _noDataWidget());
  }

  _searchCountriesFunction(search) {
    filteredCountries.clear();
    if (search.isEmpty) {
      filteredCountries = List.from(_cubit.countries);
      _cubit.refreshScreen();
      return;
    }

    for (var country in _cubit.countries) {
      if (country.name.toLowerCase().startsWith(search.toLowerCase())) {
        filteredCountries.add(country);
      }
    }

    _cubit.refreshScreen();
  }

  //List's child widget
  Widget _countryListTile(
      Country country, bool buildAlphabetTile, String alphabet) {
    return GestureDetector(
      onTap: () {
        _clearSearchBar();
        BlocProvider.of<NavigatorBloc>(context)
            .add(NavigateToCovidDetailScreen(country));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (buildAlphabetTile)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
              child: Text(
                alphabet,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            color: Colors.white,
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 28, right: 20),
                leading: MyNetworkImage(networkUrl: country.flagUrl),
                title: Text(country.name),
                trailing: (alphabet == "Current Location" &&
                        (country.isoCode == "in"))
                    ? const Icon(
                        Icons.check,
                        color: Colors.deepOrange,
                      )
                    : null),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  // no date widget
  _noDataWidget() {
    return const Center(
        child: Text(
      "No Countries Found !",
      style: TextStyle(fontSize: 20, color: Colors.pink),
    ));
  }

  void _fetchCountries() {
    _cubit.fetCountries();
  }

  Widget _errorWidget(HomeErrorState state) {
    return ErrorPage(
      statusCode: state.statusCode,
      onRefresh: () {
        _fetchCountries();
      },
    );
  }
}
