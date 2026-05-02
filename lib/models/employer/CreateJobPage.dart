import 'package:flutter/material.dart';
import 'package:local_hire/models/employer/constant/JobStatusType.dart';
import 'package:local_hire/models/employer/constant/jobType.dart';
import 'package:local_hire/models/employer/constant/shiftType.dart';
import 'package:provider/provider.dart';

import '../../services/ApiServices.dart';
import '../apiModel/RequestJobPostDto.dart';

class CreateJobPage extends StatefulWidget {
  final VoidCallback onJobCreated;

  const CreateJobPage({super.key, required this.onJobCreated});

  @override
  State<CreateJobPage> createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  final _formKey = GlobalKey<FormState>();

  final salaryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final areaController = TextEditingController();
  final pinController = TextEditingController();
  final descriptionController = TextEditingController();

  JobType? jobType;
  JobStatus? jobStatus;
  ShiftType? shiftType;


  // final List<String> jobTypes = [
  //   "HELPER",
  //   "CASHIER",
  //   "LOADER",
  //   "SALES",
  //   "CLEANING",
  //   "SECURITY",
  //   "DELIVERY",
  //   "OTHER"
  // ];
  //
  // final List<String> shiftTypes = [
  //   "MORNING",
  //   "EVENING",
  //   "NIGHT",
  //   "FULL_DAY"
  // ];
  //
  // final List<String> jobStatus = [
  //   "OPEN",
  //   "CLOSED"
  // ];


  @override
  Widget build(BuildContext context) {
    final api =  context.read<ApiService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Job"),
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
                validator: (v){
                  if( v == null || v.isEmpty){
                    return "Salary cannot be empty";
                  }
                },
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
                validator: (v){
                  if(v == null || v.isEmpty){
                    return "State is required";
                  }
                  return null;
                },
                decoration: _inputDecoration("State", Icons.map),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: cityController,
                validator: (v){
                  if(v == null || v.isEmpty){
                    return "City is required";
                  }

                  return null;
                },
                decoration: _inputDecoration("City", Icons.location_city),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: areaController,
                validator: (v){
                  if(v== null || v.isEmpty){
                    return "Area is required";
                  }
                  return null;
                },
                decoration: _inputDecoration("Area", Icons.home),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: pinController,
                keyboardType: TextInputType.number,
                validator: (v){
                  if(v == null || v.isEmpty){
                    return "Pincode is required";
                  }
                  if(v.length != 6){
                    return "Enter valid pincode";
                  }
                },
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

                      // ///  API logic here later
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

                      api.createJob(job);
                      print("Save job");
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (_)=>jobsPage())
                      // );
                      widget.onJobCreated();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Save Job"),
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