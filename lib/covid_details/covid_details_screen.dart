import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../core/core.dart';
import '../navigator/navigator.dart';
import 'covid_details.dart';

class CovidStatisticsScreen extends StatefulWidget {
  final Country selectedCountry;

  const CovidStatisticsScreen({
    required this.selectedCountry,
    Key? key,
  }) : super(key: key);

  @override
  State<CovidStatisticsScreen> createState() => _CovidStatisticsScreenState();
}

class _CovidStatisticsScreenState extends State<CovidStatisticsScreen> {
  late final CovidDetailCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<CovidDetailCubit>();
    _fetchCountryDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(widget.selectedCountry.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Future.delayed(Duration(milliseconds: 2), () {
                  _fetchCountryDetails();
                });
              },
              icon: Icon(
                Icons.refresh,
                size: 28,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CovidDetailCubit, CovidDetailState>(
            builder: (context, state) {
          if (state is CovidDetailsErrorState) {
            return ErrorPage(
                statusCode: state.statusCode,
                onRefresh: () {
                  _fetchCountryDetails();
                });
          }

          return (state is CovidDetailLoadingState)
              ? const CovidDetailScreenShimmer()
              : _content();
        }),
      ),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(
            28.0, (MediaQuery.of(context).size.height * 0.01 + 28), 28, 28),
        decoration: _pageBackground(),
        child: Column(
          children: [
            _header(),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: commonCard(
                  "Deaths",
                  _cubit.covidStat?.covidDetails?.first.deaths?.total ?? 0,
                  height: 150,
                  textColor: Colors.red,
                )),
                Expanded(
                    child: commonCard(
                  "Recovered",
                  _cubit.covidStat?.covidDetails?.first.cases?.recovered ?? 0,
                  height: 150,
                  textColor: Colors.green,
                )),
              ],
            ),
            commonCard(
              "Active Cases",
              _cubit.covidStat?.covidDetails?.first.cases?.active ?? 0,
            ),
            commonCard(
              "Serious / Critical",
              _cubit.covidStat?.covidDetails?.first.cases?.critical ?? 0,
              showNewCases: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget commonCard(String title, int cases,
      {bool showNewCases = false, double? height, Color? textColor}) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          formatNumber(cases),
                          style: TextStyle(
                              fontSize: 24,
                              color: textColor ?? Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                if (showNewCases)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Cases".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${_cubit.covidStat?.covidDetails?.first.cases?.newCases ?? 0}",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  _fetchCountryDetails() {
    _cubit.fetchCovidDetailForCountry(widget.selectedCountry);
  }

  BoxDecoration _pageBackground() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            stops: const [0.3, 0.25],
            end: Alignment.bottomCenter,
            colors: [Colors.red, WCovidStatColor.backGroundColor()]));
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('dd MMM, y GGG hh:mm a').format(DateTime.now()),
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w200)),
            const SizedBox(
              height: 8,
            ),
            Text(
                "Total Cases in ${_cubit.covidStat?.covidDetails?.first.country}",
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
            const SizedBox(
              height: 8,
            ),
            Text(
                formatNumber(
                  _cubit.covidStat?.covidDetails?.first.cases?.total ?? 0,
                ),
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: MyNetworkImage(
            networkUrl: widget.selectedCountry.flagUrl,
          ),
        ),
      ],
    );
  }
}
