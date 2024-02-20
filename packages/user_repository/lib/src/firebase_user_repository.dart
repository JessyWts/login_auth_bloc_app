import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/core/toast.dart';
import 'package:user_repository/user_repo.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;


  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await userCollection.doc(myUser.userId).set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      showToast(isSuccess: true, message: 'Sign In with success');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(isSuccess: false, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showToast(isSuccess: false, message: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        showToast(isSuccess: false, message: 'The email address is not valid.');
      } else if (e.code == 'user-disabled') {
        showToast(isSuccess: false, message: 'The user corresponding to the given email has been disabled.');
      }else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        showToast(isSuccess: false, message: 'Wrong password or email.');
      } else {
        log(e.code);
        showToast(isSuccess: false, message: 'An error occurred: ${e.code}');
      }
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async{
    try {
      final UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email, 
        password: password
      );

      myUser = myUser.copyWith(
        userId: credential.user!.uid
      );
      showToast(isSuccess: true, message: 'Sign Up with success.');
      return myUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showToast(isSuccess: false, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast(isSuccess: false, message: 'The account already exists for that email.');
      } else if (e.code == 'operation-not-allowed') {
        showToast(isSuccess: false, message: 'The signup is not enable.');
      } else {
        log(e.code);
        showToast(isSuccess: false, message: 'An error occurred: ${e.code}');
      }
      rethrow;
    }
  }

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseuser) {
    final user = firebaseuser;
    return user;
    });
  }
  
  @override
  Future<void> signOut() async {
    try {
     await _firebaseAuth.signOut();
   } catch (e) {
     log(e.toString());
     rethrow;
   }
  }
  
  @override
  Future<MyUser> getMyUser(String myUserId) async {
    try {
     return userCollection.doc(myUserId).get().then((value) => 
      MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!))
     );
   } catch (e) {
     log(e.toString());
     rethrow;
   }
  }
  
}