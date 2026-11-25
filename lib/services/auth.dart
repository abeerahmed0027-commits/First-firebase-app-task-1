import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // sign up method
  Future<String> signup({required String email , required String password }) async{
     try {
       await _auth.createUserWithEmailAndPassword(
           email: email, password: password);
       return "success";
     } on FirebaseAuthException catch (e) {
        return e.message.toString();
     }
  }
  // sign in method
Future<String> signin({required String email , required String password }) async{
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return "success";
    }  on FirebaseAuthException catch (e) {
      return e.message.toString();

    }
}
// sign out method
  Future<void> signout() async {
    await _auth.signOut();
  }
}