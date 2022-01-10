import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fastmarket/adverts/advert_details/advert_details_page.dart';
import 'package:fastmarket/adverts/advert_list_tile.dart';
import 'package:fastmarket/adverts/all_adverts_page_bloc.dart';
import 'package:fastmarket/adverts/create_advert_page.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:fastmarket/widget/show_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllAdvertsPage extends StatefulWidget {
  @override
  _AllAdvertsPageState createState() => _AllAdvertsPageState();

  //Create bloc on widget initialization
  static Widget withBloc() => BlocProvider(
    //Add load event right after bloc creation
      create: (context) => AllAdvertsPageBloc(context.read())..add(LoadEvent()),
      child: AllAdvertsPage());
}

class _AllAdvertsPageState extends State<AllAdvertsPage> {
  late AllAdvertsPageBloc _bloc;
  final ScrollController _controller = ScrollController();
  StreamSubscription<void>? _refreshStream;

  @override
  void initState() {
    _bloc = context.read();
    _controller.addListener(() {
      //If list reaches max extent - 100px -> load more adverts
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 100 &&
          !_bloc.state.loadingNewData) {
        _bloc.add(LoadMoreEvent());
      }
    });
    _refreshStream = _bloc.refreshStream().listen((event) async {
      //If refresh stream yields new value -> load adverts again
      _bloc.add(LoadEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    //Don't forget to dispose controllers and sreams on end of widget lifecycle
    _refreshStream?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Return bloc builder to feed body widget the latest state of bloc
    return BlocBuilder<AllAdvertsPageBloc, AllAdvertsPageState>(
        builder: (context, state) {
      return _buildBody(state);
    });
  }

  //Build adverts depending on state of the bloc
  Widget _buildAdverts(AllAdvertsPageState state) {
    if (state.progress) { //Loading body
      return Container(
        height: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
        child: const Center(child: CircularProgressIndicator.adaptive()),
      );
    } else if (state.allAdverts.isEmpty) { //Empty body
      return Container(
          padding:
              const EdgeInsets.only(top: 160, bottom: 16, left: 16, right: 16),
          child: Center(
            child: Column(
              children: const <Widget>[
                Text("There are no advertisements in this selection",
                    style: AppTypography.title),
                SizedBox(height: 24),
                Text("You can add your advertisement by pressing '+' button",
                    style: AppTypography.body1)
              ],
            ),
          ));
    } else { //Body with adverts
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            //Use builder to save resources/unload unrendered elements
              controller: _controller, //Controller for pagination
              itemBuilder: (item, index) {
                final advert = state.allAdverts[index];
                return AdvertListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AdvertDetailsPage.withBloc(advert)));
                    },
                    advertisement: advert);
              },
              itemCount: state.allAdverts.length),
        ),
      );
    }
  }

  //Body of the page, receives bloc's state
  Widget _buildBody(AllAdvertsPageState state) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            //Button to refresh adverts manually
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _bloc.add(LoadEvent());
                  },
                  child: const Icon(
                    Icons.refresh,
                    size: 24.0,
                  ),
                )),
          ],
          title: Text("Browse advertisements",
              style: AppTypography.app_bar.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.patternBlue,
          shadowColor: AppColors.transparent,
        ),
        body: Stack(children: [
          Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Column(
                children: [
                  //Category selector
                  const Align(
                      child: Text("Select category:"),
                      alignment: Alignment.centerLeft),
                  const SizedBox(height: 8),
                  DropdownSearch<String>(
                      mode: Mode.MENU,
                      showSelectedItems: true,
                      items: const [
                        "All categories",
                        "Electronics",
                        "Clothes",
                        "Vehicles",
                        "Hobby",
                        "Other"
                      ],
                      dropdownBuilder: (context, category) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child:
                              Text(category ?? "", style: AppTypography.body1),
                        );
                      },
                      popupItemBuilder: (context, category, selected) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: Text(category,
                              style: AppTypography.body1.copyWith(
                                  color: selected
                                      ? AppColors.textBlack
                                      : AppColors.disabledShadow)),
                        );
                      },
                      onChanged: (category) {
                        //When user changes category -> trigger bloc event
                        if (category != null &&
                            category != state.selectedCategory) {
                          _bloc.add(SetCategoryEvent(category));
                        }
                      },
                      selectedItem: state.selectedCategory),
                  _buildAdverts(state) //Build adverts body
                ],
              )),
          //Button to add new advert
          Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                  heroTag: null,
                  child: const Icon(Icons.add),
                  onPressed: () async {
                    await showFMModalBottomSheet(
                        context: context,
                        builder: (context) => CreateAdvertPage.withBloc());
                  }))
        ]),
      );
}
