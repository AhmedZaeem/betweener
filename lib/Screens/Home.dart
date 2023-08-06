import 'package:betweener/Controllers/CachedController.dart';
import 'package:betweener/Helpers/NavigatorHelper.dart';
import 'package:betweener/Screens/MainViews/MainView.dart';
import 'package:betweener/Screens/MainViews/activeSharingView.dart';
import 'package:betweener/Screens/MainViews/profileView.dart';
import 'package:betweener/Screens/ScanQR.dart';
import 'package:betweener/Screens/SearchScreen.dart';
import 'package:betweener/Screens/auth/Login.dart';
import 'package:betweener/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Widgets/custom_floating_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with NavigatorHelper {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: index == 1
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    var controller = CachedController();
                    await controller.setData(sharedPrefKeys.user, null);
                    await controller.setData(sharedPrefKeys.token, null);
                    if (mounted) {
                      jump(context, const Login(), replace: true);
                    }
                  }),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 32.h,
                  ),
                  onPressed: () {
                    jump(context, const SearchScreen());
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.document_scanner_rounded,
                    size: 32.h,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    jump(context, const ScanQR());
                  },
                ),
              ],
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: const [
              activeSharingView(),
              MainView(),
              profileView(),
            ][index],
          ),
        ],
      ),
      bottomNavigationBar: CustomFloatingNavBar(
        currentIndex: index,
        onTap: (_) {
          setState(() => index = _);
        },
      ),
    );
  }
}
