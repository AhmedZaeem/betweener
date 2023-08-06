import 'package:betweener/Controllers/FollowersController.dart';
import 'package:betweener/Models/UserModel.dart';
import 'package:betweener/Screens/AddLink.dart';
import 'package:betweener/enums.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/CachedController.dart';
import '../../Controllers/LinksHelper.dart';
import '../../Models/Followers.dart';
import '../../Models/Link.dart';

class profileView extends StatefulWidget {
  final User? anotherUser;
  const profileView({super.key, this.anotherUser});

  @override
  State<profileView> createState() => _profileViewState();
}

class _profileViewState extends State<profileView> {
  late Future<UserModel> user;
  late Future<Followers> followers;
  late Future<List<Link>?> userLinks;
  Future<UserModel> getUser() async {
    final u =
        userModelFromJson(CachedController().getData(sharedPrefKeys.user));
    return u;
  }

  Future<List<Link>?> getUserLinks() async {
    return await getLinks(context);
  }

  @override
  void initState() {
    super.initState();
    followers = getFollowers();
    user = getUser();
    userLinks = getUserLinks();
    if (widget.anotherUser != null) {
      anotherUserLinks = getLinksByID();
      refreshScreen();
    }
  }

  late Future<List<Link>> anotherUserLinks;

  Future<List<Link>> getLinksByID() async {
    return await fetchUserLinks(widget.anotherUser!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.anotherUser == null
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddLink()))
                    .then((value) => refreshScreen());
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      body: FutureBuilder(
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 24.h),
                  Text(
                    'Profile',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(height: 24.h),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xff2D2B4E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 12.w),
                            const CircleAvatar(radius: 42),
                            SizedBox(width: 24.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30.h),
                                Text(
                                  widget.anotherUser == null
                                      ? userSnapshot.data!.user!.name!
                                      : widget.anotherUser!.name!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  widget.anotherUser == null
                                      ? userSnapshot.data!.user!.email!
                                      : widget.anotherUser!.email!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 6.h),
                                const Text(
                                  '0970000000',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                FutureBuilder(
                                  builder: (context, followersSnapshot) {
                                    if (followersSnapshot.hasData) {
                                      return widget.anotherUser == null
                                          ? Row(
                                              children: <Widget>[
                                                Chip(
                                                    label: Text(
                                                        'followers ${followersSnapshot.data!.followersCount}'),
                                                    backgroundColor:
                                                        const Color(
                                                            0xffFFD465)),
                                                SizedBox(width: 16.w),
                                                Chip(
                                                    label: Text(
                                                        'following ${followersSnapshot.data!.followingCount}'),
                                                    backgroundColor:
                                                        const Color(
                                                            0xffFFD465)),
                                              ],
                                            )
                                          : const SizedBox.shrink();
                                    } else {
                                      return const Chip(
                                          label: CircularProgressIndicator());
                                    }
                                  },
                                  future: followers,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        end: 15.w,
                        top: 10.h,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 28.h,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return PositionedDirectional(
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 38.w),
                                  child: InkWell(
                                    onTap: () async {
                                      await _launchURL(
                                          snapshot.data![index].link!);
                                    },
                                    child: Slidable(
                                      enabled: true,
                                      endActionPane: widget.anotherUser == null
                                          ? ActionPane(
                                              motion: const StretchMotion(),
                                              extentRatio: .5,
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) {},
                                                  backgroundColor: Colors.white,
                                                  flex: 1,
                                                  icon: Icons.abc,
                                                  foregroundColor: Colors.white,
                                                ),
                                                SlidableAction(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                  flex: 4,
                                                  onPressed: (context) async {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => AddLink(
                                                                linkToEdit: snapshot
                                                                        .data![
                                                                    index]))).then(
                                                        (value) {
                                                      if (value) {
                                                        refreshScreen();
                                                      }
                                                    });
                                                    refreshScreen();
                                                  },
                                                  backgroundColor:
                                                      const Color(0xffFFD465),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                ),
                                                SlidableAction(
                                                  onPressed: (context) {},
                                                  backgroundColor: Colors.white,
                                                  flex: 1,
                                                  icon: Icons.abc,
                                                  foregroundColor: Colors.white,
                                                ),
                                                SlidableAction(
                                                  flex: 4,
                                                  onPressed: (context) async {
                                                    await CoolAlert.show(
                                                      context: context,
                                                      type:
                                                          CoolAlertType.confirm,
                                                      showCancelBtn: true,
                                                      backgroundColor:
                                                          Colors.red,
                                                      onConfirmBtnTap:
                                                          () async {
                                                        var x =
                                                            await deleteLink(
                                                                snapshot
                                                                    .data![
                                                                        index]
                                                                    .id!);
                                                        if (x && mounted) {
                                                          CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType
                                                                .success,
                                                            text:
                                                                'Link was deleted successfully',
                                                            title: 'Successful',
                                                          ).then((value) =>
                                                              refreshScreen());
                                                        }
                                                      },
                                                      title: 'Delete ',
                                                      text:
                                                          'Are you sure you want to delete this link?',
                                                    );
                                                    refreshScreen();
                                                  },
                                                  backgroundColor:
                                                      const Color(0xFFF56C61),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.r),
                                                ),
                                              ],
                                            )
                                          : null,
                                      child: InkWell(
                                        onTap: () async {
                                          final Uri url = Uri.parse(
                                              snapshot.data![index].link!);
                                          await launchUrl(url);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? const Color(0xffFEE2E7)
                                                : const Color(0xffE7E5F1),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 13.w, vertical: 11.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].title!,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  letterSpacing: 3,
                                                  color: index % 2 == 0
                                                      ? const Color(0xff783341)
                                                      : const Color(0xff2D2B4E),
                                                ),
                                              ),
                                              Text(
                                                snapshot.data![index].link!,
                                                style: TextStyle(
                                                  color: index % 2 == 0
                                                      ? const Color(0xff9B6A73)
                                                      : const Color(0xff807D99),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 24.h);
                              },
                              itemCount: snapshot.data!.length),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    future: widget.anotherUser == null
                        ? userLinks
                        : anotherUserLinks,
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: user,
      ),
    );
  }

  void refreshScreen() async {
    followers = getFollowers();
    user = getUser();
    userLinks = getUserLinks();
    setState(() {});
  }

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
