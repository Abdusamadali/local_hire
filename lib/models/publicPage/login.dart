import 'package:flutter/material.dart';
import 'package:local_hire/services/ApiServices.dart';
import 'package:provider/provider.dart';
import '../../provider/authProvider.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onToggle;
  const LoginPage({super.key, required this.onToggle});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _username = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false; // 🔥 loading state

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return Scaffold(
      resizeToAvoidBottomInset: true, // 🔥 keyboard safe

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

              /// 🔥 IMAGE
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.8, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  "assets/images/img_1.png",
                  height: 180,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Welcome Back",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Login to continue",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
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
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔥 LOGIN BUTTON WITH ANIMATION
                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            onPressed: isLoading ? null : () async {
                              setState(() => isLoading = true);

                              try {
                                final body = await api.login(
                                  _username.text,
                                  _password.text,
                                );

                                final token = body?.token;
                                final role = body?.role;
                                final authProvider = context.read<AuthProvider>();

                                if (token != null) {
                                  await authProvider.setAuth(token, role!);
                                  print('token loaded--------------------------$token-----------------');
                                } else {
                                  print('token not loaded---------------------------------------');
                                }

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
                                "LOGIN",
                                key: ValueKey("text"),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// SIGNUP
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                            ),

                            GestureDetector(
                              onTap: widget.onToggle,
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Color(0xFF203A43),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
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