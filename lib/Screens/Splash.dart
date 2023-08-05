import 'package:betweener/Controllers/CachedController.dart';
import 'package:betweener/Helpers/NavigatorHelper.dart';
import 'package:betweener/Screens/auth/Login.dart';
import 'package:betweener/Screens/onBoarding.dart';
import 'package:betweener/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with NavigatorHelper {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    var cachedController = CachedController();
    bool? passOnBoarding =
        await cachedController.getData(sharedPrefKeys.passedBoarding);
    if (passOnBoarding != null && passOnBoarding) {
      var user = await cachedController.getData(sharedPrefKeys.user);
      if (user == null && mounted) {
        jump(context, const Login(), replace: true);
      } else if (mounted) {
        jump(context, const Home(), replace: true);
      }
    } else if (mounted) {
      jump(context, const onBoarding(), replace: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/icon.png',
              width: 128.w,
              height: 128.w,
            ),
            SizedBox(height: 20.h),
            Text(
              'Betweener',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/images/az.svg',
              color: Colors.purpleAccent,
              width: 64.w,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
