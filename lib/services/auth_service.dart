import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:new_dhc/constants.dart';
import 'package:new_dhc/model/utils.dart';

import '../model/end_user.dart';
import 'database_service.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final passwordLength = 15;

  Future<bool> login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      EndUser endUser = await DatabaseService().getUser();
      if (endUser.userType == medico) {
        FirebaseAuth.instance.signOut();
        return false;
      }
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<String?> createUser(String email) async {
    FirebaseApp secondaryApp = await Firebase.initializeApp(
        name: "Secondary", options: Firebase.app().options);
    FirebaseAuth secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

    try {
      UserCredential userCredential =
          await secondaryAuth.createUserWithEmailAndPassword(
              email: email, password: generateRandomString(passwordLength));
      return await resetPassword(email) ? userCredential.user!.uid : null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    secondaryAuth.signOut();
    return null;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }
}
