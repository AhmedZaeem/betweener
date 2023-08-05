import 'package:betweener/Controllers/authController.dart';
import 'package:betweener/Helpers/NavigatorHelper.dart';
import 'package:betweener/Models/UserModel.dart';
import 'package:betweener/Screens/Home.dart';
import 'package:betweener/Screens/auth/Register.dart';
import 'package:betweener/Widgets/MyTextFormField.dart';
import 'package:betweener/Widgets/My_Button.dart';
import 'package:betweener/enums.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Controllers/CachedController.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with NavigatorHelper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  final _key = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 110.h),
                SvgPicture.asset('assets/images/login.svg'),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 43.w),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        MyTextFormField(
                          controller: _emailController,
                          hint: 'Example@gmail.com',
                          textFieldLabel: appLocale.email,
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                              return 'Please Enter a valid Email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),
                        MyTextFormField(
                          controller: _passwordController,
                          hint: '* * * * * *',
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please Enter a valid password';
                            }
                            return null;
                          },
                          textFieldLabel: appLocale.password,
                          isPassword: true,
                        ),
                        SizedBox(height: 24.h),
                        My_Button(
                          buttonText: appLocale.login.toUpperCase(),
                          textColor: Theme.of(context).colorScheme.surface,
                          onTap: preformLogin,
                        ),
                        SizedBox(height: 26.h),
                        My_Button(
                          buttonText: appLocale.register.toUpperCase(),
                          textColor: Theme.of(context).colorScheme.secondary,
                          buttonColor: Colors.transparent,
                          btnBoarder: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 3.w,
                          ),
                          onTap: () => jump(context, const Register()),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '-    or    -',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 19.h),
                        My_Button(
                          buttonColor: Colors.transparent,
                          textColor: const Color(0xffA90606),
                          btnBoarder: Border.all(
                              color: const Color(0xffA90606), width: 2.w),
                          buttonText: appLocale.signInWithGoogle.toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading
              ? PositionedDirectional(
                  top: MediaQuery.of(context).size.height / 2,
                  start: MediaQuery.of(context).size.width / 2 - 20,
                  child: const CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
          loading
              ? PositionedDirectional(
                  child: Container(
                    color: Colors.grey.withOpacity(.3),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  preformLogin() async {
    if (_key.currentState!.validate()) {
      setState(() => loading = true);
      await login({
        'email': _emailController.text,
        'password': _passwordController.text
      }).then((value) async {
        if (value == null) {
          CoolAlert.show(
            backgroundColor: Colors.white,
            context: context,
            title: 'Error',
            type: CoolAlertType.error,
            text: "An error has occurred",
            animType: CoolAlertAnimType.slideInUp,
          );
        } else {
          CachedController controller = CachedController();
          await controller.setData(sharedPrefKeys.user, userModelToJson(value));
          await controller.setData(sharedPrefKeys.token, value.token);
          setState(() => loading = false);
          if (mounted) {
            jump(context, const Home(), replace: true);
          }
        }
      });
    }
    setState(() => loading = false);
  }
}
