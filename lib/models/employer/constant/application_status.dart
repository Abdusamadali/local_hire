
enum ApplicationStatus {
  pending,
  accepted,
  rejected,
}
extension ApplicationStatusExtension on ApplicationStatus {
  String get value {
    switch (this) {
      case ApplicationStatus.pending:
        return "PENDING";
      case ApplicationStatus.accepted:
        return "ACCEPTED";
      case ApplicationStatus.rejected:
        return "REJECTED";
    }
  }
}