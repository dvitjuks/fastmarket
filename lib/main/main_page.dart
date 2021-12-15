import 'package:fastmarket/main/main_page_bloc.dart';
import 'package:fastmarket/profile/profile_page.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();

  static Widget withBloc() => BlocProvider<MainPageBloc>(
        child: MainPage(),
        create: (context) => MainPageBloc(context.read(), context.read())
      );
}

class _MainPageState extends State<MainPage> {
  late MainPageBloc _bloc;
  int _selectedIndex = 3;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _widgetOptions = <Widget>[
      const Scaffold(body: Center(child: Text("Page One"),),),
      const Scaffold(body: Center(child: Text("Page Two"),),),
      const Scaffold(body: Center(child: Text("Page Three"),),),
      ProfilePage.withBloc()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainPageBloc, MainPageState>(
        builder: (context, state) => Scaffold(
          body: IndexedStack(
            children: _widgetOptions,
            index: _selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            elevation: 3,
            items: <BottomNavigationBarItem>[
              _navItem(IconsProvider.INFO,
                  "One"),
              _navItem(IconsProvider.INFO,
                  "Two"),
              _navItem(IconsProvider.INFO,
                  "Three"),
              _navItem(IconsProvider.PROFILE,
                  "Profile")
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.patternBlue,
            unselectedItemColor: AppColors.disabled2,
            onTap: _onItemTapped,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: AppTypography.body1.copyWith(fontSize: 12),
            unselectedLabelStyle: AppTypography.body1.copyWith(fontSize: 12),
          ),
        )
      ),
    );
  }

  BottomNavigationBarItem _navItem(String icon, String title) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        icon,
        color: AppColors.patternBlue,
      ),
      icon: SvgPicture.asset(
        icon,
        color: AppColors.disabled2,
      ),
      label: title,
    );
  }

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}
