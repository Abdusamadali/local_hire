


import 'dart:convert';

List<Post> postsFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postsToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  Employer? employer;
  int id;
  String? jobType;
  Location? location;
  int? salary;
  String? shiftType;
  String? status;
  String? description;
  Post({
    this.employer,
    required this.id,
    this.jobType,
    this.location,
    this.salary,
    this.shiftType,
    this.status,
    this.description
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    employer:
    json["employer"] == null ? null : Employer.fromJson(json["employer"]),
    id: json["id"],
    jobType: json["jobType"],
    location:
    json["location"] == null ? null : Location.fromJson(json["location"]),
    salary: json["salary"],
    shiftType: json["shiftType"],
    status: json["status"],
    description: json["description"]
  );

  Map<String, dynamic> toJson() => {
    "employer": employer?.toJson(),
    "id": id,
    "jobType": jobType,
    "location": location?.toJson(),
    "salary": salary,
    "shiftType": shiftType,
    "status": status,
    "description":description
  };
}

class Employer {
  int? id;
  String? username;

  Employer({
    this.id,
    this.username,
  });

  factory Employer.fromJson(Map<String, dynamic> json) => Employer(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}

class Location {
  String? area;
  String? city;
  String? pincode;
  String? state;

  Location({
    this.area,
    this.city,
    this.pincode,
    this.state,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    area: json["area"],
    city: json["city"],
    pincode: json["pincode"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "area": area,
    "city": city,
    "pincode": pincode,
    "state": state,
  };
}