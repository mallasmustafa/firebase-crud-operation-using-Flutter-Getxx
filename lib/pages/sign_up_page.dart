import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/controllers/auth_controller.dart';
import 'package:firebase_crud/pages/home_page.dart';
import 'package:firebase_crud/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "SIGN UP",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "SIGN UP WITH EMAIL AND PASSWORD",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: authController.emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.deepPurple,
                            ),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: authController.passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.deepPurple,
                            ),
                            hintText: "password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => authController.isLoading.value
                          ? const CircularProgressIndicator()
                          : InkWell(
                              onTap: () async {
                                authController.signUpWithEmailAndPassword();
                              },
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.deepPurple,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_clock_sharp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "SIGNUP",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      const SizedBox(height: 10),
                      Obx(
                        () => authController.isLoading.value
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.facebook_outlined,
                                      color: Colors.blue,
                                      size: 34,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () async {
                                      UserCredential? userCredential =
                                          await authController
                                              .loginWithGoogle();
                                      if (userCredential != null) {
                                        User? user = userCredential.user;
                                        print('Signed in as: ${user?.displayName}');
                                        Get.to(const HomePage());
                                      } else {
                                        print("error");
                                      }
                                    },
                                    icon: const Icon(
                                      Ionicons.logo_google,
                                      size: 34,
                                    ),
                                  ),
                                ],
                              ),
                      )
                    ]),
              ),
              const SizedBox(height: 20),
              const Text("Already have a account"),
              InkWell(
                onTap: () {
                  Get.to(const LoginPage());
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepPurple,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_clock_sharp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
