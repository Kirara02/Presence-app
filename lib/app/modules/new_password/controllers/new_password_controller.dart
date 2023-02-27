import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController(text: "");

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    try {
      if (newPassC.text.isNotEmpty) {
        if (newPassC.text != 'password') {
          String email = auth.currentUser!.email!;

          await auth.currentUser!.updatePassword(newPassC.text);

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: email,
            password: newPassC.text,
          );

          Get.offAllNamed(Routes.HOME);
        } else {
          Get.snackbar(
            "Terjadi kesalahan",
            "Password baru harus diubah. jangan 'password' kembali",
          );
        }
      } else {
        Get.snackbar(
          "Terjadi kesalahan",
          "Password baru wajib diisi.",
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
      } else if (e.code == 'wrong-password') {}
      Get.snackbar("Terjadi Kesalahan",
          "Password terlalu lemah, setidaknya masukan 6 karakter");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat membuat password baru");
    }
  }
}
