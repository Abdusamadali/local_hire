import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_hire/models/apiModel/Post.dart';
import 'package:provider/provider.dart';

import '../../services/ApiServices.dart';

class EmployeeJobsPage extends StatefulWidget {
  const EmployeeJobsPage({super.key});

  @override
  State<EmployeeJobsPage> createState() => _EmployeeJobsPageState();
}

class _EmployeeJobsPageState extends State<EmployeeJobsPage> {

  late Future<List<Post>> _jobsFuture;
  String _searchQuery = "";
  List<Post> _allJobs = [];

  final TextEditingController _searchController = TextEditingController();

  String? selectedCity;
  String? selectedType;
  String? selectedShift;

  @override
  void initState() {
    super.initState();
    _jobsFuture = fetchJobs();
  }

  Future<List<Post>> fetchJobs() async {
    final api = context.read<ApiService>();
    final res = await api.getJobEmployee(); // get all jobs
    _allJobs = (res.data as List).map((e) => Post.fromJson(e)).toList();

    return _allJobs;
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
        title: const Text("Available Jobs"),
        actions: [

          /// logout
          IconButton(
            onPressed: api.logOut,
            icon: const Icon(Iconsax.logout),
          )
        ],
      ),

      body: Column(
        children: [

          animatedSearchBar(),
          Expanded(
            child: RefreshIndicator(
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
                    return const Center(child: Text("No jobs available"));
                  }

                  final posts = _searchQuery.isEmpty
                      ? _allJobs
                      : _allJobs.where((job) {
                    final query = _searchQuery;

                    return (job.jobType?.toLowerCase().contains(query) ?? false) ||
                        (job.shiftType?.toLowerCase().contains(query) ?? false) ||
                        (job.location?.city?.toLowerCase().contains(query) ?? false) ||
                        (job.location?.state?.toLowerCase().contains(query) ?? false) ||
                        (job.description?.toLowerCase().contains(query) ?? false);
                  }).toList();

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return jobCard(posts[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget animatedSearchBar() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: -50.0, end: 0.0),

      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Opacity(
            opacity: (1 - (value.abs() / 50)).clamp(0, 1),
            child: child,
          ),
        );
      },

      child: buildSearchBar(),
    );
  }

  Widget buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: TextField(
        controller: _searchController,

        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },

        onSubmitted: (_) {
          _searchFromBackend();
        },

        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Search jobs, city, type...",
          border: InputBorder.none,

          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// CLEAR
              if (_searchQuery.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchQuery = "";
                      _searchController.clear();
                      _jobsFuture = Future.value(_allJobs);
                    });
                  },
                ),

              /// SEARCH BUTTON (🔥 triggers backend)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchFromBackend,
              ),
            ],
          ),
        ),
      )
    );
  }

  Future<void> _searchFromBackend() async {
    final api = context.read<ApiService>();

    final params = {
      "title": _searchController.text,
      "city": selectedCity,
      "type": selectedType,
      "shift": selectedShift,
    };

    params.removeWhere((key, value) => value == null || value == "");

    try {
      final res = await api.searchJobs(params);

      final newJobs = (res.data as List)
          .map((e) => Post.fromJson(e))
          .toList();

      setState(() {
        _allJobs = newJobs; // 🔥 IMPORTANT
        _jobsFuture = Future.value(newJobs);
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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



  Widget jobCard(Post p) {

    // final api = context.read<ApiService>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),

        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () {
            showSheet(context, p);
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
                    Text("${p.salary}"),
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

                // const SizedBox(height: 14),
                //
                // /// APPLY BUTTON
                // SizedBox(
                //   width: double.infinity,
                //
                //   child: ElevatedButton(
                //     onPressed: () async {
                //
                //       try {
                //
                //         await api.applyJob(p.id);
                //
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Text("Application submitted"),
                //           ),
                //         );
                //
                //       } catch (e) {
                //
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(content: Text("Error: $e")),
                //         );
                //       }
                //     },
                //
                //     child: const Text("Apply"),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Job Details Sheet
  void showSheet(BuildContext context, Post p) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,

      builder: (context) {

        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
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

              const Text(
                "Job Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _infoRow(Icons.work, "Job Type", "${p.jobType}"),
              _infoRow(Icons.currency_rupee, "Salary", "${p.salary}"),
              _infoRow(Icons.schedule, "Shift", "${p.shiftType}"),
              _infoRow(Icons.check_circle, "Status", "${p.status}"),

              const Divider(),

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

              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [

                    /// CLOSE BUTTON
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          "Close",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// APPLY BUTTON
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {

                          final api = context.read<ApiService>();

                          try {

                            final s = await api.applyJob(p.id);
                            // if(s.data !="saved") {
                            //   throw Future.error(s.data);
                            // }
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Application submitted"),
                              ),
                            );
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: $e")),
                            );
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: const Text(
                          "Apply",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
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