import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp2/features/auth/domain/app_user.dart';
import 'package:newsapp2/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore userDatabase = FirebaseFirestore.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //Attempt signin
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //Get user doc from firestore
      DocumentSnapshot userDoc = await userDatabase
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      //Create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: userDoc['name'],
      );

      //Return user
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      //Attempt signin
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //Create user
      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      //Save userdata in firestore
      await userDatabase.collection('users').doc(user.uid).set(user.toJson());

      //Return user
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    //Get current user
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return null;
    }

    //Grab user doc (in order to access username)
    DocumentSnapshot userDoc =
        await userDatabase.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      return null;
    }

    //User exists
    return AppUser(
      uid: user.uid,
      email: user.email!,
      name: userDoc['name'],
    );
  }
}
