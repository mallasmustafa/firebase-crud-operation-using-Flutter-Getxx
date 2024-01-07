import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/pages/home_page.dart';
import 'package:firebase_crud/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
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
      } else if (e.code == "email-already-in-use") {
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
      Get.offAll(const HomePage());
    } on FirebaseAuthException catch (error) {
      print("Login Error code: ${error.code}");
      if (error.code == 'user-not-found') {
        Get.snackbar("Login Failed", "No user registered for this email");
      } else if (error.code == 'wrong-password') {
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

  Future<void> logout() async {
    try {
      isLoading.value = false;
      await auth.signOut();
      Get.offAll(LoginPage());
    } catch (e) {
      Get.snackbar("Some thing wrong", "$e");
    }
  }

  Future<UserCredential?> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        return await auth.signInWithCredential(authCredential);
      }
    } catch (e) {
      isLoading.value = false;
      print("Error during Google sign in: $e");
    }
    isLoading.value = false;
    return null;
  }

  Future<UserCredential?> signInWithFacebook() async {
    isLoading.value = true;
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        return await auth.signInWithCredential(credential);
      }else if(loginResult.status == LoginStatus.failed){
        Get.snackbar("Login Failed", "Error while facebook login");
      }
    } catch (e) {
      isLoading.value = false;
      print("Error during Facebook sign in: $e");
    }
    isLoading.value = false;
    return null;
  }
}
