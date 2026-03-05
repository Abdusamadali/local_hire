// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

PostsSocials postsFromJson(String str) => PostsSocials.fromJson(json.decode(str));

String postsToJson(PostsSocials data) => json.encode(data.toJson());

class PostsSocials {
  final List<Post>? posts;
  final int? total;
  final int? skip;
  final int? limit;

  PostsSocials({
    this.posts,
    this.total,
    this.skip,
    this.limit,
  });

  factory PostsSocials.fromJson(Map<String, dynamic> json) => PostsSocials(
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    total: json["total"],
    skip: json["skip"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "total": total,
    "skip": skip,
    "limit": limit,
  };
}

class Post {
  final int? id;
  final String? title;
  final String? body;
  final List<String>? tags;
  final Reactions? reactions;
  final int? views;
  final int? userId;

  Post({
    this.id,
    this.title,
    this.body,
    this.tags,
    this.reactions,
    this.views,
    this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    title: json["title"],
    body: json["body"],
    tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
    reactions: json["reactions"] == null ? null : Reactions.fromJson(json["reactions"]),
    views: json["views"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "body": body,
    "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
    "reactions": reactions?.toJson(),
    "views": views,
    "userId": userId,
  };
}

class Reactions {
  final int? likes;
  final int? dislikes;

  Reactions({
    this.likes,
    this.dislikes,
  });

  factory Reactions.fromJson(Map<String, dynamic> json) => Reactions(
    likes: json["likes"],
    dislikes: json["dislikes"],
  );

  Map<String, dynamic> toJson() => {
    "likes": likes,
    "dislikes": dislikes,
  };
}
