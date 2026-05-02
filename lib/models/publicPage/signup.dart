import 'package:flutter/material.dart';
import 'package:local_hire/services/ApiServices.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onToggle;
  const SignupPage({super.key, required this.onToggle});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  String selectedRole = "EMPLOYEE";

  final _username = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false; // 🔥 loading state

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// 🔥 IMAGE ANIMATION
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Image.asset(
                  "assets/images/img_2.png",
                  key: ValueKey(selectedRole),
                  height: 180,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Join LocalHire",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 ROLE CHIPS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  roleChip("EMPLOYEE"),
                  const SizedBox(width: 12),
                  roleChip("EMPLOYER"),
                ],
              ),

              const SizedBox(height: 30),

              /// 🔥 FORM
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        buildField("Username", Icons.person, _username),
                        const SizedBox(height: 20),

                        buildField("Password", Icons.lock, _password, isPassword: true),
                        const SizedBox(height: 30),

                        /// 🔥 SIGNUP BUTTON WITH ANIMATION
                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {

                              setState(() => isLoading = true);

                              try {
                                final api = context.read<ApiService>();
                                String? res =  await api.signUp(
                                  _username.text,
                                  _password.text,
                                  selectedRole,
                                );

                                /// ✅ Optional success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(res??"created!!")),
                                );

                              } catch (e) {
                                print("Error: $e");
                              }

                              setState(() => isLoading = false);
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF203A43),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),

                              child: isLoading
                                  ? const SizedBox(
                                key: ValueKey("loader"),
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "SIGN UP",
                                key: ValueKey("text"),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: widget.onToggle,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF203A43),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 ROLE CHIP
  Widget roleChip(String role) {

    final isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),

        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 🔥 INPUT FIELD
  Widget buildField(
      String hint,
      IconData icon,
      TextEditingController controller,
      {bool isPassword = false}) {

    return TextField(
      controller: controller,
      obscureText: isPassword,

      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),

        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}