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
          backgroundColor: WCovidStatColor.backGroundColor(),
          title: const Text(
            "Cowid Status",
            style: TextStyle(color: Colors.blueAccent),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: Card(
        //elevation: 0,
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

  String oldA = "*";
  String newA = "*";

  Widget _listOfCountries() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: (0.to(filteredCountries.length - 1).map((index) {
          oldA = newA;
          print("$oldA ${newA}");

          newA = filteredCountries[index].name.trim()[0].toUpperCase();
          return GestureDetector(
            onTap: () {
              BlocProvider.of<NavigatorBloc>(context)
                  .add(NavigateToCovidDetailScreen(filteredCountries[index]));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (oldA != newA)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16),
                    child: Text(
                      newA,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    leading: MyNetworkImage(
                        networkUrl: filteredCountries[index].flagUrl),
                    title: Text(filteredCountries[index].name),
                  ),
                ),
                const Divider(
                  height: 0,
                  color: Colors.grey,
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
