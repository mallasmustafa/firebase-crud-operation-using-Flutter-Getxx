import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  Future<void> signUpWithEmailAndPassword() async {
    isLoading.value = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      isLoading.value = false;
      Get.to(HomePage());
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Get.snackbar("Weak Password", "This password is to weak");
      }
     else if (e.code == "email-already-in-use") {
        Get.snackbar("🤦‍♀️Invalid email", "This email is already in register");
      }
    } catch (e) {
      Get.snackbar("Wrong", e.toString());
    }
    isLoading.value = false;
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
      // Get.offAll(HomePage());
    } on FirebaseAuthException catch (error) {
      print("Login Error code: ${error.code}");
      if (error.code == 'user-not-found') {
        Get.snackbar("Login Failed", "No user registered for this email");
      } else if (error.code == 'wrong-password') {
        print("Wrong password");
        Get.snackbar("Login Failed", "Please enter the correct password");
      } else {
        print("Other login error occurred: ${error.message}");
        // Handle other error cases if needed
      }
    } catch (e) {
      Get.snackbar("Wrong", e.toString());
    }
    isLoading.value = false;
  }
}
