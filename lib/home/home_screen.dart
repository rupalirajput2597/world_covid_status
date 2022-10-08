import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_covid_status/core/core.dart';
import 'package:world_covid_status/navigator/bloc/navigator_bloc.dart';
import 'package:world_covid_status/navigator/bloc/navigator_event.dart';

import 'bloc/bloc.dart';
import 'home_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeBloc _bloc;

  late final TextEditingController searchController;
  List<Country> filteredCountries = [];

  @override
  void initState() {
    _bloc = BlocProvider.of<HomeBloc>(context);
    searchController = TextEditingController();
    filteredCountries = [];
    _bloc.add(HomeInitialEvent());
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
            "Covid Status",
            style: TextStyle(color: Colors.pink),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is CountriesFetchSuccessfulState) {
              filteredCountries = List.from(_bloc.countries);
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
      //elevation: 0,
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 0),
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

  void _clearSearchBar() {
    if (searchController.text.isNotEmpty) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      FocusScope.of(context).focusedChild?.unfocus();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => searchController.clear());
      filteredCountries = List.from(_bloc.countries);
      searchController.clear();

      _bloc.add(HomeRefreshEvent());

      return;
    }
  }

  Widget _listOfCountries() {
    String oldAlphabet = "*";
    String newAlphabet = "*";

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: (0.to(filteredCountries.length - 1).map((index) {
          oldAlphabet = newAlphabet;
          newAlphabet = filteredCountries[index].name.trim()[0].toUpperCase();

          if (index == filteredCountries.length - 1) {
            oldAlphabet = "*";
            newAlphabet = "*";
          }

          return GestureDetector(
            onTap: () {
              _clearSearchBar();
              BlocProvider.of<NavigatorBloc>(context)
                  .add(NavigateToCovidDetailScreen(filteredCountries[index]));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (oldAlphabet != newAlphabet)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16),
                    child: Text(
                      newAlphabet,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: MyNetworkImage(
                        networkUrl: filteredCountries[index].flagUrl),
                    title: Text(filteredCountries[index].name),
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
        }).toList()),
      ),
    );
  }

  _searchCountriesFunction(search) {
    filteredCountries.clear();
    if (search.isEmpty) {
      filteredCountries = List.from(_bloc.countries);
      _bloc.add(HomeRefreshEvent());

      return;
    }

    _bloc.countries.forEach((Country country) {
      // if (country.name.toLowerCase().contains(search.toLowerCase())) {
      if (country.name.toLowerCase().startsWith(search.toLowerCase())) {
        filteredCountries.add(country);
      }
    });

    _bloc.add(HomeRefreshEvent());
  }
}

// child: ListView.separated(
//   padding: const EdgeInsets.all(8),
//   itemCount: _bloc.countries.length,
//   itemBuilder: (BuildContext context, int index) {
//     oldA = newA;
//     print("$oldA ${newA}");
//
//     newA = _bloc.countries[index].name.trim()[0].toUpperCase();
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (oldA != newA) Text("$newA"),
//         Container(
//           color: Colors.white,
//           child: ListTile(
//             leading: Image.network(_bloc.countries[index].flagUrl ??
//                 "https://flagcdn.com/h40/in.png"),
//             title: Text(_bloc.countries[index].name),
//           ),
//         ),
//       ],
//     );
//   },
//   separatorBuilder: (context, i) {
//     return const Divider(
//       color: Colors.grey,
//     );
//   },
// ),
// child: ListView.builder(
//   padding: const EdgeInsets.all(8),
//   itemCount: _bloc.countries.length,
//   itemBuilder: (BuildContext context, int index) {
//     oldA = newA;
//     newA = _bloc.countries[index].name[0];
//     print(_bloc.countries[index].name[0]);
//
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (oldA != newA) Text("$newA"),
//         Container(
//           color: Colors.white,
//           child: ListTile(
//             leading: Image.network(_bloc.countries[index].flagUrl ??
//                 "https://flagcdn.com/h40/in.png"),
//             title: Text(_bloc.countries[index].name),
//           ),
//         ),
//         const Divider(
//           color: Colors.grey,
//         ),
//       ],
//     );
//   },
// ),
