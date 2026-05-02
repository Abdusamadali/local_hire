import '../employer/constant/application_status.dart';
import 'Post.dart';
import 'User.dart';

class JobApplication {
  final int id;
  final Post jobPost;
  final AppUser employer;
  final AppUser employee;
  final ApplicationStatus status;

  JobApplication({
    required this.id,
    required this.jobPost,
    required this.employer,
    required this.employee,
    required this.status,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],

      jobPost: Post.fromJson(json['jobPost']), // ✅ matches backend DTO

      employer: AppUser.fromJson(json['employer']),
      employee: AppUser.fromJson(json['employee']),

      status: ApplicationStatus.values.firstWhere(
            (e) => e.name.toUpperCase() == json['status'],
        orElse: () => ApplicationStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobPost': jobPost.toJson(), // ✅ matches backend
      'employer': employer.toJson(),
      'employee': employee.toJson(),
      'status': status.name.toUpperCase(),
    };
  }
}