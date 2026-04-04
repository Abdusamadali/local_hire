

enum JobStatus {
  open,
  closed,
}

extension JobStatusExtension on JobStatus {
  String get value {
    switch (this) {
      case JobStatus.open:
        return "OPEN";
      case JobStatus.closed:
        return "CLOSED";
    }
  }
}