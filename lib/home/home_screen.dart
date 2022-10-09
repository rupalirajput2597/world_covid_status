import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
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
    _fetchCountries(false);
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
    return RefreshIndicator(
      onRefresh: () async {
        Future.delayed(Duration(milliseconds: 2), () {
          _fetchCountries(true);
        });
      },
      child: Column(
        children: [_searchFieldWidget(), _listOfCountries()],
      ),
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
  ///
  /// using here the grouped list package widget [groupedContryList]
  ///  but I have also created the custom GroupedList View [_customGroupListView]
  ///
  Widget _listOfCountries() {
    return Expanded(
        child: filteredCountries.isNotEmpty
            ? Column(
                children: [
                  if ((searchController.text.isEmpty) &&
                      (_cubit.currentCountry != null))
                    _countryListTile(filteredCountries[0],
                        searchController.text.isEmpty, "Current Location"),
                  Expanded(child: groupedContryList()),
                ],
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

  // no date widget
  _noDataWidget() {
    return const Center(
        child: Text(
      "No Countries Found !",
      style: TextStyle(fontSize: 20, color: Colors.pink),
    ));
  }

  void _fetchCountries(isRefreshing) {
    _cubit.fetCountries(context, isRefreshing: isRefreshing);
  }

  Widget _errorWidget(HomeErrorState state) {
    return ErrorPage(
      statusCode: state.statusCode,
      onRefresh: () {
        _fetchCountries(false);
      },
    );
  }

  Widget groupedContryList() {
    return GroupedListView<Country, String>(
      elements: filteredCountries,
      groupBy: (country) {
        return country.name.trim()[0].toUpperCase();
      },
      groupComparator: (value1, value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) => item1.name.compareTo(item2.name),
      order: GroupedListOrder.DESC,
      groupSeparatorBuilder: (String alphabet) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
        child: Text(
          alphabet,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return GestureDetector(
          onTap: () {
            _clearSearchBar();
            BlocProvider.of<NavigatorBloc>(context)
                .add(NavigateToCovidDetailScreen(element));
          },
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 28, right: 20),
                    leading: MyNetworkImage(networkUrl: element.flagUrl),
                    title: Text(element.name),
                    trailing: ((_cubit.currentCountry != null) &&
                            (element.isoCode == _cubit.currentCountry?.isoCode))
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
      },
    );
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
                        (_cubit.currentCountry != null))
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

  ///My custom GroupedList
  ///please copy this code paste it in [_listOfCountries ] widget instead of
  /// Column(
  ///                     children: [
  ///                       if (searchController.text.isEmpty)
  ///                         _countryListTile(filteredCountries[0],
  ///                             searchController.text.isEmpty, "Current Location"),
  ///                       Expanded(child: groupedContryList()),
  ///                    ],
  ///                  )

/*  String oldAlphabet = "*";
  String newAlphabet = "*";
 ListView(
      padding: const EdgeInsets.all(8),
      children: (0.to(filteredCountries.length - 1).map((index) {
        oldAlphabet = newAlphabet;
        newAlphabet = filteredCountries[index].name.trim()[0].toUpperCase();

        //resetting aphabets
        if (index == filteredCountries.length - 1) {
          oldAlphabet = "*";
          newAlphabet = "*";
        }

        return index == 0
            ? _countryListTile(
                filteredCountries[index],
                searchController.text.isEmpty,
                "Current Location") //current contry Tile
            : _countryListTile(filteredCountries[index],
                (oldAlphabet != newAlphabet), newAlphabet); //other Countries
      }).toList()),
    ) */

}
