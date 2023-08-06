import 'package:betweener/Screens/MainViews/profileView.dart';
import 'package:betweener/Screens/Splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Controllers/CachedController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CachedController().initCache();
  runApp(MyApp());
}

const apiLink = 'http://www.osamapro.online/api';

class MyApp extends StatelessWidget {
  final SystemUiOverlayStyle _style =
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_style);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Material App',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('en')],
          locale: const Locale('en'),
          theme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xffFFD465),
                  secondary: const Color(0xff2D2B4E),
                  surface: const Color(0xff784E00),
                  primaryContainer: const Color(0xff2D2B4E),
                ),
          ),
          darkTheme: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  brightness: Brightness.dark,
                  primary: const Color(0xffFFD465),
                  secondary: const Color(0xff2D2B4E),
                  surface: const Color(0xff784E00),
                  primaryContainer: const Color(0xff2D2B4E),
                ),
          ),
          themeMode: ThemeMode.light,
          home: const Scaffold(
            body: Splash(),
          ),
          initialRoute: '/',
          routes: {
            '/profile': (context) => const profileView(),
          },
        );
      },
    );
  }
}
