import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_hire/models/apiModel/Post.dart';
import 'package:local_hire/models/apiModel/api_job_post_dto.dart' as dto;
import 'package:local_hire/models/employer/updatePage.dart';
import 'package:local_hire/sevices/ApiServices.dart';
import 'package:provider/provider.dart';

import 'CreateJobPage.dart';

class jobsPage extends StatefulWidget {
  const jobsPage({super.key});

  @override
  State<jobsPage> createState() => _jobsPageState();
}

class _jobsPageState extends State<jobsPage> {

  late Future<List<Post>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = fetchJobs();
  }

  Future<List<Post>> fetchJobs() async {
    final api = context.read<ApiService>();
    final res = await api.getJobsEmployer();
    return (res.data as List).map((e) => Post.fromJson(e)).toList();
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _jobsFuture = fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My jobs'),
        actions: [

          /// create job
          IconButton(
            onPressed: _refreshJobs, // 🔥 just refresh
            icon: const Icon(Icons.refresh),
          ),

          /// logout
          IconButton(
            onPressed: api.logOut,
            icon: const Icon(Icons.output),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _refreshJobs,

        child: FutureBuilder<List<Post>>(
          future: _jobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No jobs found"));
            }

            final posts = snapshot.data!;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final p = posts[index];
                return jobs(p, context);
              },
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "open":
        return Colors.green;
      case "closed":
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  Widget jobs(Post p, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () async {
            showSheet(context, p);

            // showSheet(context, p);
          },

          onLongPress: () {
            HapticFeedback.mediumImpact();
            updateJob(context, p);
          },

          onDoubleTap: () {

          },
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
                      p.jobType ?? "Job",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(p.status).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        p.status ?? "",
                        style: TextStyle(
                          color: _statusColor(p.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.currency_rupee, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      "${p.salary}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 5),
                    Text("${p.shiftType}"),
                  ],
                ),

                const Divider(height: 20),

                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 18, color: Colors.red),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${p.location?.area}, ${p.location?.city}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "${p.location?.state} • ${p.location?.pincode}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// bottom sheet
  void showSheet(BuildContext context, Post p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.68,
          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Job Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _infoRow(Icons.badge, "Job ID", "${p.id}"),
              _infoRow(Icons.work, "Job Type", "${p.jobType}"),
              _infoRow(Icons.currency_rupee, "Salary", "${p.salary}"),
              _infoRow(Icons.schedule, "Shift", "${p.shiftType}"),
              _infoRow(Icons.check_circle, "Status", "${p.status}"),

              const Divider(height: 30),

              const Text(
                "Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              _infoRow(Icons.location_city, "City", "${p.location?.city}"),
              _infoRow(Icons.map, "State", "${p.location?.state}"),
              _infoRow(Icons.pin_drop, "Pincode", "${p.location?.pincode}"),
              _infoRow(Icons.home, "Area", "${p.location?.area}"),

              const Spacer(),


              Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO edit button
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO:- Change logic
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Close Job",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// close
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );

}

// update section
//   void showUpdateDialog(BuildContext context, Post p) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Confirm Update"),
//           content: Text("Are you sure you want to update this job?"),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//
//           actions: [
//             /// Cancel Button
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context); // close dialog
//               },
//               child: Text("Cancel"),
//             ),
//
//             /// Update Button
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // close dialog
//
//                 updateJob(context,p); // call your update function
//               },
//               child: Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }

  void showUpdateDialog(BuildContext context, Post p) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 Top Row (Title + Close)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Update Job",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 10),

                /// Message
                Text(
                  "Do you want to update this job?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 25),

                /// Buttons Row
                Row(
                  children: [

                    /// Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Update
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          updateJob(context, p);
                        },
                        child: const Text("Update"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCloseDialog(BuildContext context, Post p,) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 Top Row (Title + Close)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Close Job",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 10),

                /// Message
                Text(
                  "Do you want to close this job?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 25),

                /// Buttons Row
                Row(
                  children: [

                    /// Cancel
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Update
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          updateJob(context, p);
                        },
                        child: const Text("Close"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateJob(BuildContext context, Post p) {
    print(p.description);

    final Dto = dto.RequestJobPostDto(
      salary: p.salary ?? 0,
      status: p.status ?? "",
      shiftType: p.shiftType ?? "",
      jobType: p.jobType ?? "",
      description: p.description ?? "",

      location: dto.Location(
        state: p.location?.state ?? "",
        city: p.location?.city ?? "",
        area: p.location?.area ?? "",
        pincode: p.location?.pincode ?? "",
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => updatePage(post: Dto,id: p.id,),
      ),
    );
  }



  void closeJob(BuildContext context, Post job){
      final api =context.read<ApiService>();
     api.closeJob(job.id);
  }


  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 10),

          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

}

