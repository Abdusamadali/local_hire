


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../sevices/ApiServices.dart';
import '../apiModel/api_job_post_dto.dart';
import 'constant/JobStatusType.dart';
import 'constant/jobType.dart';
import 'constant/shiftType.dart';

class updatePage extends StatefulWidget {
  final RequestJobPostDto post;
  final int id;
  const updatePage({super.key, required this.post,required this.id });

  @override
  State<updatePage> createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final post = widget.post;

  
    salaryController.text = post.salary.toString();
    descriptionController.text = post.description??"";

    stateController.text = post.location.state;
    cityController.text = post.location.city;
    areaController.text = post.location.area;
    pinController.text = post.location.pincode;

    jobType = JobType.values.firstWhere(
          (e) => e.name.toLowerCase() == post.jobType.toLowerCase(),
          orElse: ()=>JobType.helper
    );

    shiftType = ShiftType.values.firstWhere(
          (e) => e.name.toLowerCase() == post.shiftType.toLowerCase(),
        orElse: ()=>ShiftType.fullDay
    );

    jobStatus = JobStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == post.status.toLowerCase(),
          orElse: ()=>JobStatus.open
    );

  }


  final _formKey = GlobalKey<FormState>();

  final salaryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final pinController = TextEditingController();
  final descriptionController = TextEditingController();

  JobType? jobType ;
  JobStatus? jobStatus;
  ShiftType? shiftType;
  


  @override
  Widget build(BuildContext context) {
    final api =  context.read<ApiService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Job"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              /// Salary
              TextFormField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Salary", Icons.currency_rupee),
              ),

              const SizedBox(height: 16),

              /// Job Type
              DropdownButtonFormField<JobType>(
                initialValue: jobType,
                decoration: _inputDecoration("Job Type", Icons.work),
                items: JobType.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => jobType = value);
                },
              ),

              const SizedBox(height: 16),

              /// Shift Type
              DropdownButtonFormField<ShiftType>(
                initialValue: shiftType,
                decoration: _inputDecoration("Shift Type", Icons.schedule),
                items: ShiftType.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => shiftType = value);
                },
              ),

              const SizedBox(height: 16),

              /// Job Status
              DropdownButtonFormField<JobStatus>(
                initialValue: jobStatus,
                decoration: _inputDecoration("Job Status", Icons.check_circle),
                items: JobStatus.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => jobStatus = value);
                },
              ),

              const SizedBox(height: 25),

              /// Location title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: stateController,
                decoration: _inputDecoration("State", Icons.map),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: cityController,
                decoration: _inputDecoration("City", Icons.location_city),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: areaController,
                decoration: _inputDecoration("Area", Icons.home),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: pinController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Pincode", Icons.pin_drop),
              ),

              const SizedBox(height: 30),

              //description
              SizedBox(
                height: 200,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  maxLength: 200,
                  controller: descriptionController,
                  textAlignVertical: TextAlignVertical.top, // ✅ FIX

                  decoration: InputDecoration(
                    hintText: "Write description...",
                    filled: true,
                    label: Text("Description"),
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(16),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              /// Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      // /// You will add API logic here later
                      //  String salary = salaryController.text;
                      //  String state = stateController.text;
                      //  String city = cityController.text;
                      //  String area = areaController.text;
                      //  String pinCode = pinController.text;

                      final job  = RequestJobPostDto(
                        salary: int.parse(salaryController.text),
                        status: jobStatus!.value,
                        shiftType: shiftType!.value,
                        jobType: jobType!.value,
                        description: descriptionController.text,
                        location: Location(
                          state: stateController.text,
                          city: cityController.text,
                          area: areaController.text,
                          pincode: pinController.text,
                        ),
                      );

                      api.updateJob(job,widget.id);

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (_)=>jobsPage())
                      // );

                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Update Job"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
