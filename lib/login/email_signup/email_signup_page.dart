import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:fastmarket/login/create_profile/create_profile_page.dart';
import 'package:fastmarket/login/email_login/email_login_page.dart';
import 'package:fastmarket/login/email_signup/email_signup_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_appbar.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/ct_password_form_field.dart';
import 'package:fastmarket/theme/ct_snackbar.dart';
import 'package:fastmarket/theme/ct_text_form_field.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailSignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailSignUpPageState();

  static Widget withBloc() => BlocProvider<EmailSignUpPageBloc>(
        child: EmailSignUpPage(),
        create: (context) => EmailSignUpPageBloc(context.read()),
      );
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  late EmailSignUpPageBloc _bloc;
  bool continueEnabled = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final error = _bloc.state.error;
    return Scaffold(
      body: BlocConsumer<EmailSignUpPageBloc, EmailSignUpPageState>(
        listener: (context, state) {
          if (error != null) {
            _bloc.add(ClearErrorEvent());
            Scaffold.of(context).showSnackBar(CTSnackBar(
              text: error.toString(),
            ));
          }
          if (state.registered == true) {
            _continueToProfileCreation();
          } else {
            setState(() {
              continueEnabled = state.isRegisterEnabled();
            });
          }
        },
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  Widget _buildBody(EmailSignUpPageState state) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: CTAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildLabel("E-mail", 32),
                  _buildEmailField((value) => _bloc.add(SetEmailEvent(value))),
                  _buildLabel("Password", 32),
                  _buildPasswordField(
                      (value) => _bloc.add(SetPasswordEvent(value))),
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
                  _buildContinueButton(state),
                  _buildLoginPrompt()
                ],
              ),
            ),
          )
        ],
      ));

  Widget _buildHeader() => Text(
        "Register using email",
        style: AppTypography.headline1.copyWith(color: AppColors.textBlue),
      );

  Widget _buildPasswordField(ValueChanged<String> onChanged) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CTPasswordFormField(onChanged, autovalidate: true,
          validator: (value) {
        if (value.isNotEmpty && value.length < 6) {
          return "Password must be at least 6 characters long";
        }
        return null;
      }));

  Widget _buildEmailField(ValueChanged<String> onChanged) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CTTextFormField(onChanged, autovalidate: true,
          formFieldValidator: (value) {
        if (!value.isEmpty && !EmailValidator.validate(value)) {
          return "Please enter valid e-mail address";
        }
        return null;
      }));

  Widget _buildLabel(String text, double topPadding) => Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Text(
          text,
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      );

  Widget _buildContinueButton(EmailSignUpPageState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
      child: CTLoadingButton(
        "Continue",
        continueEnabled ? () => _bloc.add(RegisterEvent()) : null,
        color: AppColors.patternBlue,
        isLoading: state.progress,
      ),
    );
  }

  Widget _buildLoginPrompt() => GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => EmailLoginPage.withBloc()));
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: Platform.isIOS ? 48 : 32),
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "Already have an account?",
                  style:
                      AppTypography.body3.copyWith(color: AppColors.mainGrey)),
              TextSpan(
                  text: " Log in here",
                  style: AppTypography.body3_bold
                      .copyWith(color: AppColors.textBlack))
            ]),
          ),
        ),
      );

  void _continueToProfileCreation() {
    _bloc.add(ClearRegisteredEvent());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: _bloc,
              child: CreateProfilePage(),
            )));
  }
}
