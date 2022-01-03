import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:fastmarket/adverts/create_advert_page_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_back_button.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateAdvertPage extends StatefulWidget {
  @override
  _CreateAdvertPageState createState() => _CreateAdvertPageState();

  static Widget withBloc() => BlocProvider<CreateAdvertPageBloc>(
        create: (context) =>
            CreateAdvertPageBloc(context.read(), context.read()),
        child: CreateAdvertPage(),
      );
}

class _CreateAdvertPageState extends State<CreateAdvertPage> {
  late CreateAdvertPageBloc _bloc;

  @override
  void initState() {
    _bloc = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAdvertPageBloc, CreateAdvertPageState>(
        listener: (context, state) {
          if (state.advertWasPublished == true) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Scaffold(
                backgroundColor: AppColors.white,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: AppColors.white,
                  shadowColor: Colors.transparent,
                  leading:
                      CTBackButton(AppColors.textBlue, AppColors.textBlack),
                  centerTitle: true,
                  title: Text("Create advertisement",
                      style: AppTypography.app_bar
                          .copyWith(color: AppColors.textBlue)),
                ),
                body: CustomScrollView(
                  scrollBehavior: const MaterialScrollBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            state.imagePath.isEmpty
                                ? Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.disabledShadow
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            width: 300,
                                            height: 300,
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.add_a_photo),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Add your image",
                                                  style: AppTypography.body1,
                                                )
                                              ],
                                            ))),
                                        onTap: _chooseImage),
                                  )
                                : Align(
                                    child: GestureDetector(
                                        onTap: _chooseImage,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.file(
                                              File(state.imagePath),
                                              width: 300,
                                              height: 300,
                                              fit: BoxFit.cover),
                                        )),
                                    alignment: Alignment.center,
                                  ),
                            const SizedBox(height: 32),
                            const Text("Advertisement title:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            CTTextFormField(
                                (text) => {_bloc.add(SetTitleEvent(text))}),
                            const SizedBox(height: 32),
                            const Text("Category:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: const [
                                  "Electronics",
                                  "Clothes",
                                  "Vehicles",
                                  "Hobby",
                                  "Other"
                                ],
                                onChanged: (category) {
                                  if (category != null) {
                                    _bloc.add(SetCategoryEvent(category));
                                  }
                                },
                                selectedItem: null),
                            const SizedBox(height: 32),
                            const Text("Description:",
                                style: AppTypography.caption1),
                            const SizedBox(height: 4),
                            CTTextFormField(
                                (text) =>
                                    {_bloc.add(SetDescriptionEvent(text))},
                                isMultiline: true),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
                        child: CTLoadingButton(
                          "Publish",
                          state.canPublishAdvert() == true
                              ? () {
                                  _bloc.add(PublishEvent());
                                }
                              : null,
                          color: state.canPublishAdvert() == true
                              ? AppColors.patternBlue
                              : AppColors.disabled1,
                          isLoading: state.progress,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  void _chooseImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      print(xFile.path);
      _bloc.add(SetImagePathEvent(xFile.path));
    }
  }
}
