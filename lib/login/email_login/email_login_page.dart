import 'dart:io';
import 'package:fastmarket/login/email_login/email_login_page_bloc.dart';
import 'package:fastmarket/login/email_signup/email_signup_page.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_appbar.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/ct_password_form_field.dart';
import 'package:fastmarket/theme/ct_snackbar.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailLoginPageState();

  static Widget withBloc() => BlocProvider<EmailLoginPageBloc>(
    child: EmailLoginPage(),
    create: (context) => EmailLoginPageBloc(context.read()),
  );
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  late EmailLoginPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EmailLoginPageBloc, EmailLoginPageState>(
        listener: (context, state) {
          final error = state.error;
          if (error != null) {
            _bloc.add(ClearErrorEvent());
            Scaffold.of(context).showSnackBar(CTSnackBar(
              text: error.toString(),
            ));
          }
        },
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(EmailLoginPageState state) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: CTAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  _buildEmailLabel(),
                  _buildEmailTextField(),
                  _buildPasswordLabel(),
                  _buildPasswordTextField(),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildLogInButton(state),
                  _buildSignUpPrompt()
                ],
              ),
            ),
          )
        ],
      ));

  Widget _buildHeader() => Text(
    "Log in using e-mail",
    textAlign: TextAlign.center,
    style: AppTypography.headline1.copyWith(color: AppColors.textBlue),
  );

  Widget _buildEmailLabel() => Padding(
    padding: const EdgeInsets.only(top: 32),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      ],
    ),
  );

  Widget _buildEmailTextField() => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: CTTextFormField(
          (value) {
        _bloc.add(SetEmailEvent(value));
      },
    ),
  );

  Widget _buildPasswordLabel() => Padding(
    padding: const EdgeInsets.only(top: 32),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      ],
    ),
  );

  Widget _buildPasswordTextField() => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: CTPasswordFormField(
          (value) {
        _bloc.add(SetPasswordEvent(value));
      },
    ),
  );

  Widget _buildLogInButton(EmailLoginPageState state) => Padding(
    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
    child: CTLoadingButton(
      "Log in",
      state.isButtonEnabled()
          ? () {
        _bloc.add(LoginEvent());
      }
          : null,
      color: AppColors.patternBlue,
      isLoading: state.progress,
    ),
  );

  Widget _buildSignUpPrompt() => GestureDetector(
    onTap: () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => EmailSignUpPage.withBloc()));
    },
    child: Padding(
      padding: EdgeInsets.only(bottom: Platform.isIOS ? 48 : 32),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: "Don't have an account? ",
              style:
              AppTypography.body3.copyWith(color: AppColors.mainGrey)),
          TextSpan(
              text: "Sign up here",
              style: AppTypography.body3_bold
                  .copyWith(color: AppColors.textBlack))
        ]),
      ),
    ),
  );
}
