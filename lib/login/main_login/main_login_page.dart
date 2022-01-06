import 'package:fastmarket/login/email_login/email_login_page.dart';
import 'package:fastmarket/login/email_signup/email_signup_page.dart';
import 'package:fastmarket/login/main_login/main_login_page_bloc.dart';
import 'package:fastmarket/theme/colors.dart';
import 'package:fastmarket/theme/ct_loading_button.dart';
import 'package:fastmarket/theme/icons_provider.dart';
import 'package:fastmarket/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainLoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainLoginPageState();

  static Widget withBloc() => BlocProvider<MainLoginPageBloc>(
      child: MainLoginPage(),
      create: (context) => MainLoginPageBloc(context.read()));
}

class _MainLoginPageState extends State<MainLoginPage> {
  late MainLoginPageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(),
      );
  }

  Widget _buildBody() => Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          _buildImage(),
          _buildHeader(),
          _buildDescription(),
          const SizedBox(
            height: 56,
          ),
          _buildGoogleButton(),
          _buildEmailLogin(),
          _buildRegisterText()
        ]),
      ));

  Widget _buildImage() => SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: SvgPicture.asset(IconsProvider.HANDSHAKE,
          height: 250,
          width: 250,
          color: AppColors.textBlue,
        ),
      ));

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Text(
          "Welcome",
          style: AppTypography.headline1.copyWith(color: AppColors.textBlue),
        ),
      );

  Widget _buildDescription() => Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Text(
          "to the FastMarket",
          style: AppTypography.body3.copyWith(color: AppColors.mainGrey),
        ),
      );

  Widget _buildGoogleButton() => Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: CTLoadingButton(
          "Sign in with Google",
          () {
            _bloc.add(LoginWithGoogleEvent());
          },
          isLoading: false,
          color: AppColors.errorRed,
          icon: IconsProvider.GOOGLE_LOGIN,
          withShadow: false,
        ),
      );

  Widget _buildEmailLogin() => Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: CTLoadingButton(
          "Sign in with e-mail",
          () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmailLoginPage.withBloc()));
          },
          color: AppColors.patternBlue,
          isLoading: false,
        ),
      );

  Widget _buildRegisterText() => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmailSignUpPage.withBloc()));
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
          child: Text(
            "Don't have an account? Sign up here",
            style:
                AppTypography.body3_bold.copyWith(color: AppColors.textBlack),
          ),
        ),
      );
}
