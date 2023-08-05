import 'package:betweener/Controllers/CachedController.dart';
import 'package:betweener/Helpers/NavigatorHelper.dart';
import 'package:betweener/Models/Link.dart';
import 'package:betweener/Models/UserModel.dart';
import 'package:betweener/Screens/AddLink.dart';
import 'package:betweener/enums.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../Controllers/LinksHelper.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with NavigatorHelper {
  late Future<UserModel> user;
  late Future<List<Link>?> userLinks;
  @override
  void initState() {
    super.initState();

    user = getUser();
    userLinks = getUserLinks();
  }

  Future<UserModel> getUser() async {
    final u = await CachedController().getData(sharedPrefKeys.user);
    return userModelFromJson(u);
  }

  Future<List<Link>?> getUserLinks() async {
    return await getLinks(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, linkSnapshot) {
        if (linkSnapshot.hasData) {
          return FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var name = snapshot.data!.user!.name!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 46.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        'Hello, $name!',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 34.h),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(32.h),
                          child: QrImageView(
                            data: snapshot.data!.user!.id.toString(),
                          ),
                        ),
                        PositionedDirectional(
                          end: 20.w,
                          top: 16.h,
                          child: SvgPicture.asset('assets/images/Vector.svg'),
                        ),
                        PositionedDirectional(
                          end: 20.w,
                          bottom: 16.h,
                          child: SvgPicture.asset('assets/images/Vector1.svg'),
                        ),
                        PositionedDirectional(
                          start: 20.w,
                          top: 16.h,
                          child: SvgPicture.asset('assets/images/Vector2.svg'),
                        ),
                        PositionedDirectional(
                          start: 20.w,
                          bottom: 16.h,
                          child: SvgPicture.asset('assets/images/Vector3.svg'),
                        ),
                      ],
                    ),
                    Divider(
                      height: 68.h,
                      thickness: 2.w,
                      indent: 70.w,
                      endIndent: 70.w,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 24.w),
                      child: SizedBox(
                        height: 80,
                        child: Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 116,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: index == linkSnapshot.data!.length
                                      ? const Color(0xffE7E5F1)
                                      : Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: index < linkSnapshot.data!.length
                                    ? GestureDetector(
                                        onLongPress: () {
                                          CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            showCancelBtn: true,
                                            backgroundColor: Colors.red,
                                            onConfirmBtnTap: () async {
                                              var x = await deleteLink(
                                                  linkSnapshot
                                                      .data![index].id!);
                                              if (x && mounted) {
                                                CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.success,
                                                  text:
                                                      'Link was deleted successfully',
                                                  title: 'Successful',
                                                ).then(
                                                    (value) => refreshScreen());
                                              }
                                            },
                                            title: 'Delete ',
                                            text:
                                                'Are you sure you want to delete this link?',
                                          ).then((value) => refreshScreen());
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(linkSnapshot
                                                .data![index].title!),
                                            Text(
                                                '@${linkSnapshot.data![index].username}'),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddLink()))
                                              .then((value) {
                                            if (value) {
                                              refreshScreen();
                                            }
                                            return null;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.add, size: 32.h),
                                            const Text('Add More'),
                                          ],
                                        ),
                                      ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 24);
                            },
                            itemCount: linkSnapshot.data!.length + 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            future: user,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: userLinks,
    );
  }

  void refreshScreen() {
    user = getUser();
    userLinks = getUserLinks();
    setState(() {});
  }
}
