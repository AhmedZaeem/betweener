import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Controllers/FollowersController.dart';
import '../Controllers/SearchController.dart';
import '../Models/Followers.dart';
import '../Models/UserModel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    myFollowers = getMyFollowers();
    _searchController = TextEditingController();
  }

  List<User> users = [];
  Future<Followers>? myFollowers;
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<Followers> getMyFollowers() async {
    return await getFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, followings) {
          if (followings.hasData) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (value) async {
                      if (value.isNotEmpty) {
                        users = await getSearchData(value);
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Username to search',
                      border: const OutlineInputBorder(),
                      suffixIcon: Icon(
                        Icons.search,
                        size: 32.h,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(users[index].name!),
                          trailing: Chip(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              label: TextButton(
                                onPressed: () {},
                                child: Text(
                                  followings.data!.following!
                                          .contains(users[index])
                                      ? 'Following'
                                      : 'Follow',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              )),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 20.h);
                      },
                      itemCount: users.length,
                    ),
                  )
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        future: myFollowers,
      ),
    );
  }
}