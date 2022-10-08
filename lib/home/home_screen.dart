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
  late final HomeCubit _cubit;

  late final TextEditingController searchController;
  List<Country> filteredCountries = [];

  @override
  void initState() {
    _cubit = context.read<HomeCubit>();
    searchController = TextEditingController();
    filteredCountries = [];
    _fetchCountries();
    super.initState();
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
            "Covid Reports",
            style: TextStyle(color: Colors.pink),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
            if (state is CountriesFetchSuccessfulState) {
              filteredCountries = List.from(_cubit.countries);
            }

            if (state is HomeErrorState) {
              return ErrorPage(
                statusCode: state.statusCode,
                onRefresh: () {
                  _fetchCountries();
                },
              );
            }

            return (state is HomeLoadingState)
                ? const HomeShimmer()
                : Column(
                    children: [_searchFieldWidget(), _listOfCountries()],
                  );
          }),
        ));
  }

  _searchFieldWidget() {
    return Card(
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextField(
        controller: searchController,
        onChanged: (a) {
          _searchCountriesFunction(a);
        },
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
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

                  if (index == filteredCountries.length - 1) {
                    oldAlphabet = "*";
                    newAlphabet = "*";
                  }

                  return _countryListTile(filteredCountries[index],
                      (oldAlphabet != newAlphabet), newAlphabet);
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            color: Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 28),
              leading: MyNetworkImage(networkUrl: country.flagUrl),
              title: Text(country.name),
            ),
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
}
