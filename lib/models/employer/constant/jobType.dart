enum JobType {
  helper,
  cashier,
  loader,
  sales,
  cleaning,
  security,
  delivery,
  other,
}

extension JobTypeExtension on JobType {
  String get value {
    switch (this) {
      case JobType.helper:
        return "HELPER";
      case JobType.cashier:
        return "CASHIER";
      case JobType.loader:
        return "LOADER";
      case JobType.sales:
        return "SALES";
      case JobType.cleaning:
        return "CLEANING";
      case JobType.security:
        return "SECURITY";
      case JobType.delivery:
        return "DELIVERY";
      case JobType.other:
        return "OTHER";
    }
  }
}