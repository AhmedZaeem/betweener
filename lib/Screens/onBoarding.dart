import 'package:betweener/Controllers/CachedController.dart';
import 'package:betweener/Helpers/NavigatorHelper.dart';
import 'package:betweener/Screens/auth/Login.dart';
import 'package:betweener/Widgets/My_Button.dart';
import 'package:betweener/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> with NavigatorHelper {
  AppLocalizations get appLocale => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    CachedController().setData(sharedPrefKeys.passedBoarding, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/images/onBoarding.svg'),
            SizedBox(height: 163.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 34.w),
              child: My_Button(
                buttonText: appLocale.getStarted,
                buttonRadius: 12.r,
                textColor: Colors.black,
                buttonColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  jump(context, const Login(), replace: true);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
