
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  ///sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    try{
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email : email , password: password);

    firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email
        }
    );

    return userCredential;}
    on FirebaseAuthException catch (e){throw Exception(e.code);}
  }


  ///Sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, String password)async{
    try {
      //create user authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      //save user in database
      firebaseFirestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email
        }
      );

      return userCredential;


      
    }
    on FirebaseAuthException catch (e){throw Exception(e.code);}
  }

  ///log out
  Future<void> signOut() async{
    return await _auth.signOut();
  }


  ///get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }
}