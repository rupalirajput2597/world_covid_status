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
    // TODO: implement initState
    _cubit = context.read<CovidDetailCubit>();
    _cubit.fetchCovidDetailForCountry(widget.selectedCountry);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //  Navigator.pop(context);
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
          },
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<CovidDetailCubit, CovidDetailState>(
            builder: (context, state) {
          return (state is CovidDetailLoadingState)
              ? const CovidDetailScreenShimmer()
              : Container(
                  padding: EdgeInsets.fromLTRB(28.0,
                      (MediaQuery.of(context).size.height * 0.01 + 28), 28, 28),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          stops: const [0.3, 0.25],
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            WCovidStatColor.backGroundColor()
                          ])),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  DateFormat('dd MMM, y GGG hh:mm a')
                                      .format(DateTime.now()),
                                  //
                                  //"${_cubit.covidStat?.covidDetails?.first.time}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w200)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  "Total Cases in ${_cubit.covidStat?.covidDetails?.first.country}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300)),
                              SizedBox(
                                height: 8,
                              ),
                              Text(formatNumber(68887878),
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: MyNetworkImage(
                              networkUrl: widget.selectedCountry.flagUrl,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: casesCard(
                                  "Deaths",
                                  _cubit.covidStat?.covidDetails?.first.deaths
                                          ?.total ??
                                      0,
                                  height: 150,
                                  textColor: Colors.red)),
                          Expanded(
                              child: casesCard(
                                  "Recovered",
                                  _cubit.covidStat?.covidDetails?.first.cases
                                          ?.recovered ??
                                      0,
                                  height: 150,
                                  textColor: Colors.green)),
                        ],
                      ),
                      casesCard(
                        "Active Cases",
                        _cubit.covidStat?.covidDetails?.first.cases?.active ??
                            0,
                      ),
                      casesCard(
                          "Serius / Critical",
                          _cubit.covidStat?.covidDetails?.first.cases
                                  ?.critical ??
                              0,
                          showNewCases: true),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Widget casesCard(String title, int cases,
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
                        style: TextStyle(fontSize: 14),
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
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${_cubit.covidStat?.covidDetails?.first.cases?.newCases ?? 0}",
                            style: TextStyle(
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
}
