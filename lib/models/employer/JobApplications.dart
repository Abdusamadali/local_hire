import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:local_hire/models/employer/constant/application_status.dart';
import 'package:provider/provider.dart';
import '../../services/ApiServices.dart';
import '../apiModel/job_application.dart';



class JobApplications extends StatefulWidget {
  final int jobId;
   const JobApplications({super.key,required this.jobId});

  @override
  State<JobApplications> createState() => _JobApplicationsState();
}

class _JobApplicationsState extends State<JobApplications> {


  late Future<List<JobApplication>>_applications;

  @override
  void initState() {
    super.initState();
    _applications = fetchApplications(widget.jobId);
  }



  Future<List<JobApplication>> fetchApplications(int id)async {
    final api = context.read<ApiService>();
    final res = await api.getJobApplication(id); // get all jobs
    return (res.data as List).map((e) => JobApplication.fromJson(e)).toList();
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _applications = fetchApplications(widget.jobId);
    });
  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("My Applications")),
        actions: [

        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refreshJobs,
        child: FutureBuilder<List<JobApplication>>(
          future: _applications,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No jobs available"));
            }

            final jobApplication = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: jobApplication.length,
              itemBuilder: (context, index) {
                return _applicationCard(jobApplication[index]);
              },
            );
          },
        ),
      ),
    );

  }

  Color _statusColor(ApplicationStatus status) {
    if (status == ApplicationStatus.accepted) {
      return Colors.green;
    } else if (status == ApplicationStatus.rejected) {
      return Colors.red;
    }
    return Colors.orange;
  }

  Widget _applicationCard(JobApplication application) {
    final api = context.read<ApiService>();
    return Slidable(


      key: ValueKey(application.id),

      /// 👉 Swipe LEFT → Accept
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
                api.acceptJob(application.id);
            },
            backgroundColor: Colors.green,
            icon: Icons.check,
            label: 'Accept',
          ),
        ],
      ),

      /// 👉 Swipe RIGHT → Reject
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              api.rejectApplication(application.id);
            },
            backgroundColor: Colors.red,
            icon: Icons.close,
            label: 'Reject',
          ),
        ],
      ),

      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (application.jobPost.jobType).toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:  Text(
                      application.status.value.toString(),
                      style: TextStyle(
                        color: _statusColor(application.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.business, size: 18),
                  SizedBox(width: 6),
                  Text("Employer: ${application.employer.username}"),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Icon(Icons.person, size: 18),
                  SizedBox(width: 6),
                  Text("Applicant: ${application.employee.username}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
