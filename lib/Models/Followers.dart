import 'dart:convert';

Followers followersFromJson(String str) => Followers.fromJson(json.decode(str));

String followersToJson(Followers data) => json.encode(data.toJson());

class Followers {
  final int? followingCount;
  final int? followersCount;
  final List<dynamic>? following;
  final List<dynamic>? followers;

  Followers({
    this.followingCount,
    this.followersCount,
    this.following,
    this.followers,
  });

  factory Followers.fromJson(Map<String, dynamic> json) => Followers(
        followingCount: json["following_count"],
        followersCount: json["followers_count"],
        following: json["following"] == null
            ? []
            : List<dynamic>.from(json["following"]!.map((x) => x)),
        followers: json["followers"] == null
            ? []
            : List<dynamic>.from(json["followers"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "following_count": followingCount,
        "followers_count": followersCount,
        "following": following == null
            ? []
            : List<dynamic>.from(following!.map((x) => x)),
        "followers": followers == null
            ? []
            : List<dynamic>.from(followers!.map((x) => x)),
      };
}
