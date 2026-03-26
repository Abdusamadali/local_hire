class RequestJobPostDto {

  int salary;
  String status;
  String shiftType;
  String jobType;
  Location location;

  RequestJobPostDto({
    required this.salary,
    required this.status,
    required this.shiftType,
    required this.jobType,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      "salary": salary,
      "status": status,
      "shiftType": shiftType,
      "jobType": jobType,
      "location": location.toJson(),
    };
  }
}

class Location {

  String state;
  String city;
  String area;
  String pincode;

  Location({
    required this.state,
    required this.city,
    required this.area,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      "state": state,
      "city": city,
      "area": area,
      "pincode": pincode,
    };
  }
}