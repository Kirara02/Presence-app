import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      //Eksekusi
      try {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user != null) {
          String uid = credential.user!.uid;

          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "created_at": DateTime.now().toIso8601String(),
          });

          await credential.user!.sendEmailVerification();
        }

        print(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Password yang digunakan terlalu singkat",
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Terjadi Kesalahan",
            "Pegawai sudah ada. Kamu tidak bisa menambahkan pegawai dengan email ini!",
          );
        }
      } catch (e) {
        Get.snackbar(
          "Terjadi Kesalahan",
          "Tidak dapat menambahkan pegawai!",
        );
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Nama, Email, dan Nip harus diisi");
    }
  }
}
