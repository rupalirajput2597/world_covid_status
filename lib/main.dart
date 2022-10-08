import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';
import 'home/home.dart';
import 'navigator/navigator.dart';

void main() {
  runApp(const WorldCovidStatusApp());
}

class WorldCovidStatusApp extends StatefulWidget {
  const WorldCovidStatusApp({Key? key}) : super(key: key);

  @override
  State<WorldCovidStatusApp> createState() => _WorldCovidStatusAppState();
}

class _WorldCovidStatusAppState extends State<WorldCovidStatusApp> {
  late final GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    _navigatorKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigatorBloc>(
          create: (_) => NavigatorBloc(navigatorKey: _navigatorKey),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'World Covid Status',
        navigatorKey: _navigatorKey,
        theme: WCovidStatTheme.theme(context),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
