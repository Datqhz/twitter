import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter/services/firebase_database.dart';

import '../auth/user_auth.dart';

class AuthFirebaseService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserAuth? _userFromFirebase(User user){
    return user!=null? UserAuth(uid: user.uid) : null;
  }
  //auth change user stream
  Stream<UserAuth?> get user{
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
  }
  //register with email and password
  Future registerWithEmailAndPassword(String email, String password, String displayName, DateTime birth) async{
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try{
      UserCredential result = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await FirebaseDatabase(uid: user!.uid).updateUserData(email, displayName, birth);
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}