import 'dart:convert';

List<Link> linkFromJson(String str) =>
    List<Link>.from(json.decode(str).map((x) => Link.fromJson(x)));

String linkToJson(List<Link> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Link {
  final int? id;
  final String? title;
  final String? link;
  final dynamic username;
  final int? isActive;
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  Link({
    this.id,
    this.title,
    this.link,
    this.username,
    this.isActive,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        id: json["id"],
        title: json["title"],
        link: json["link"],
        username: json["username"],
        isActive: json["isActive"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
        "username": username,
        "isActive": isActive,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
