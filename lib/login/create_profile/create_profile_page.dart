import 'package:fastmarket/login/email_signup/email_signup_bloc.dart';
import 'package:fastmarket/main/main_page.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_back_button.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreateProfilePageState();

  static Widget withBloc() => BlocProvider(
        create: (context) => EmailSignUpPageBloc(context.read()),
        child: CreateProfilePage(),
      );
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  late EmailSignUpPageBloc _bloc;
  bool continueEnabled = false;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EmailSignUpPageBloc, EmailSignUpPageState>(
        listener: (context, state) {
          if (state.finished) {
            _proceedToMain();
          }
          setState(() {
            continueEnabled = state.isFinishEnabled();
          });
        },
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(EmailSignUpPageState state) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        brightness: Brightness.light,
        leading: CTBackButton(
          AppColors.accentPurple,
          AppColors.accentPurple,
          padding: 12,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildCredentialsDescription(),
                  _buildFirstNameLabel(),
                  _buildFirstNameTextField(),
                  _buildLastNameLabel(),
                  _buildLastNameTextField(),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
              hasScrollBody: false, child: _buildFinishButton(state))
        ],
      ));

  Widget _buildHeader() => Text(
        "Register using email",
        style: AppTypography.headline1.copyWith(color: AppColors.textBlue),
      );

  Widget _buildCredentialsDescription() => Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          "Choose your display first and last name",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      );

  Widget _buildFirstNameLabel() => Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Text(
          "First name",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      );

  Widget _buildFirstNameTextField() => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CTTextFormField(
          (value) {
            _bloc.add(SetFirstNameEvent(value));
          },
        ),
      );

  Widget _buildLastNameLabel() => Padding(
        padding: EdgeInsets.only(top: 32),
        child: Text(
          "Last name",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      );

  Widget _buildLastNameTextField() => Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CTTextFormField(
          (value) {
            _bloc.add(SetLastNameEvent(value));
          },
        ),
      );

  Widget _buildFinishButton(EmailSignUpPageState state) => Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 32, top: 16),
              child: CTLoadingButton(
                "Finish",
                continueEnabled
                    ? () {
                        _bloc.add(CreateUserEvent());
                      }
                    : null,
                color: AppColors.patternBlue,
                isLoading: state.progress,
              ),
            ),
          ],
        ),
      );

  void _proceedToMain() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage.withBloc()));
  }
}
