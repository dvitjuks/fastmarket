import 'dart:async';

import 'package:fastmarket/app/app_bloc.dart';
import 'package:fastmarket/app/app_routes.dart';
import 'package:fastmarket/login/main_login/main_login_page.dart';
import 'package:fastmarket/main/main_page.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AppState();

  static Widget withBloc() => BlocProvider(
      create: (context) =>
          AppBloc(context.read(), context.read())..add(CheckSessionEvent()),
      child: App());
}

class _AppState extends State<App> {
  final _navKey = GlobalKey<NavigatorState>();
  StreamSubscription<User?>? _authStream;
  StreamSubscription<void>? _loginStream;
  StreamSubscription<void>? _logoutStream;
  late AppBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();

    _authStream =
        FirebaseAuth.instance.authStateChanges().take(1).listen((user) async {
      if (user != null) {
        _bloc.add(SetUpUserEvent());
      } else {
        await loadCurrentState();
        _navKey.currentState?.pushNamedAndRemoveUntil(
            AppRoutes.login, (Route<dynamic> route) => false);
      }
    });

    _loginStream = _bloc.loginSuccess().listen((event) async {
      await loadCurrentState();
      _navKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.main, (Route<dynamic> route) => false);
    });

    _logoutStream = _bloc.logoutSuccess().listen((event) async {
      await loadCurrentState();
      print("logging out");
      _navKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    });
  }

  @override
  void dispose() {
    _authStream?.cancel();
    _loginStream?.cancel();
    _logoutStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AppBloc, AppBlocState>(
        listener: (BuildContext context, AppBlocState state) async {
          if (state.loadedUser) {
            await loadCurrentState();
            _navKey.currentState?.pushNamedAndRemoveUntil(
                AppRoutes.main, (Route<dynamic> route) => false);
          }
        },
        child: _buildApp(context),
      );

  Widget _buildApp(BuildContext context) => MaterialApp(
        navigatorKey: _navKey,
        theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(AppColors.patternBlue),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
          ),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.textBlue,
              selectionColor: AppColors.textBlue.withOpacity(0.5),
              selectionHandleColor: AppColors.textBlue),
          brightness: Brightness.light,
          textTheme: const TextTheme(button: AppTypography.body2_bold),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: AppColors.patternBlue),
        ),
        darkTheme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppColors.patternBlue,
              selectionColor: AppColors.patternBlue.withOpacity(0.5),
              selectionHandleColor: AppColors.patternBlue),
          brightness: Brightness.light,
          textTheme: const TextTheme(button: AppTypography.body2_bold),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: AppColors.patternBlue),
        ),
        themeMode: ThemeMode.system,
        routes: <String, WidgetBuilder>{
          // Launched for the first time, on a cold app launch.
          AppRoutes.root: (context) =>
              Container(color: Theme.of(context).scaffoldBackgroundColor),
          AppRoutes.launcher: (context) => Container(),
          AppRoutes.login: (context) => MainLoginPage.withBloc(),
          AppRoutes.main: (context) => MainPage.withBloc(),
        },
        initialRoute: AppRoutes.root
      );

  Future<void> loadCurrentState() async {
    while (_navKey.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 25));
    }
  }
}
