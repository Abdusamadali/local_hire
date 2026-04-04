

enum ShiftType {
  morning,
  evening,
  night,
  fullDay,
}

extension ShiftTypeExtension on ShiftType {
  String get value {
    switch (this) {
      case ShiftType.morning:
        return "MORNING";
      case ShiftType.evening:
        return "EVENING";
      case ShiftType.night:
        return "NIGHT";
      case ShiftType.fullDay:
        return "FULL_DAY";
    }
  }
}