import 'dart:async';

import 'package:fastmarket/adverts/advert_details/advert_details_page.dart';
import 'package:fastmarket/adverts/advert_list_tile.dart';
import 'package:fastmarket/adverts/create_advert_page.dart';
import 'package:fastmarket/adverts/my_adverts_page_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:fastmarket/widget/show_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyAdvertsPage extends StatefulWidget {
  @override
  _MyAdvertsPageState createState() => _MyAdvertsPageState();

  static Widget withBloc() => BlocProvider(
      create: (context) => MyAdvertsPageBloc(context.read())..add(LoadEvent()),
      child: MyAdvertsPage());
}

class _MyAdvertsPageState extends State<MyAdvertsPage> {
  late MyAdvertsPageBloc _bloc;
  final ScrollController _controller = ScrollController();
  StreamSubscription<void>? _refreshStream;

  @override
  void initState() {
    _bloc = context.read();
    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 100 &&
          !_bloc.state.loadingNewData) {
        _bloc.add(LoadMoreEvent());
      }
    });
    _refreshStream = _bloc.refreshStream().listen((event) async {
      _bloc.add(LoadEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyAdvertsPageBloc, MyAdvertsPageState>(
        builder: (context, state) {
      return _buildBody(state);
    });
  }

  Widget _buildAdverts(MyAdvertsPageState state) {
    if (state.progress) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else if (state.allAdverts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text("There are no advertisements in this selection",
                  style: AppTypography.title),
              SizedBox(height: 24),
              Text("You can add your advertisement by pressing '+' button",
                  style: AppTypography.body1)
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: SlidableAutoCloseBehavior(
              child: ListView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final advert = state.allAdverts[index];
                    return Slidable(
                      groupTag: 0,
                      key: ValueKey(index),
                      endActionPane: ActionPane(
                        extentRatio: 0.35,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              final slidable = Slidable.of(context);
                              if (slidable != null) {
                                final result = await _confirmedDelete();
                                if (result == true) {
                                  slidable.dismiss(ResizeRequest(
                                      const Duration(milliseconds: 150), () {
                                    _bloc.add(DeleteAdvertEvent(advert, index));
                                  }));
                                } else {
                                  slidable.close();
                                }
                              }
                            },
                            backgroundColor: AppColors.errorRed,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_outline,
                            label: 'Delete',
                            autoClose: false,
                          ),
                        ],
                      ),
                      child: AdvertListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    AdvertDetailsPage.withBloc(advert)));
                          },
                          advertisement: advert),
                    );
                  },
                  itemCount: state.allAdverts.length),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildBody(MyAdvertsPageState state) => Scaffold(
        appBar: AppBar(
          title: Text("My advertisements",
              style: AppTypography.app_bar.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.patternBlue,
          shadowColor: AppColors.transparent,
        ),
        body: Stack(children: [
          Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: _buildAdverts(state)),
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
                    // if (result == true) {
                    //   _bloc.add(LoadEvent());
                    // }
                  }))
        ]),
      );

  Future<bool> _confirmedDelete() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this advert?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
    return result == true;
  }
}
