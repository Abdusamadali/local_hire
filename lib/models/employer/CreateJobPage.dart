import 'package:flutter/material.dart';
import 'package:local_hire/sevices/ApiServices.dart';
import 'package:provider/provider.dart';

import '../apiModel/api_job_post_dto.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({super.key});

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

  String? jobType;
  String? shiftType;
  String? status;

  final List<String> jobTypes = [
    "HELPER",
    "CASHIER",
    "LOADER",
    "SALES",
    "CLEANING",
    "SECURITY",
    "DELIVERY",
    "OTHER"
  ];

  final List<String> shiftTypes = [
    "MORNING",
    "EVENING",
    "NIGHT",
    "FULL_DAY"
  ];

  final List<String> jobStatus = [
    "OPEN",
    "CLOSED"
  ];

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
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Salary", Icons.currency_rupee),
              ),

              const SizedBox(height: 16),

              /// Job Type
              DropdownButtonFormField<String>(
                initialValue: jobType,
                decoration: _inputDecoration("Job Type", Icons.work),
                items: jobTypes.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => jobType = value);
                },
              ),

              const SizedBox(height: 16),

              /// Shift Type
              DropdownButtonFormField<String>(
                initialValue: shiftType,
                decoration: _inputDecoration("Shift Type", Icons.schedule),
                items: shiftTypes.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => shiftType = value);
                },
              ),

              const SizedBox(height: 16),

              /// Job Status
              DropdownButtonFormField<String>(
                value: status,
                decoration: _inputDecoration("Job Status", Icons.check_circle),
                items: jobStatus.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => status = value);
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
                        status: status!,
                        shiftType: shiftType!,
                        jobType: jobType!,
                        location: Location(
                          state: stateController.text,
                          city: cityController.text,
                          area: areaController.text,
                          pincode: pinController.text,
                        ),
                      );

                      api.createJob(job);
                      print("Save job");

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