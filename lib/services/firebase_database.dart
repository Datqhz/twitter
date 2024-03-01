import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseDatabase{

  final String uid;
  FirebaseDatabase({required this.uid});
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('user');

  Future updateUserData(String email, String displayName, DateTime birth) async{
    return await userCollection.doc(uid).set({
      'username': '',
      'display_name': displayName,
      'email': email,
      'birth': birth,
      'bio' : '',
      'status': true,
      'location': '',
      'phone': '',
    });
  }
  Future<bool> findAccountByEmail(String email) async{
    try {
      final docRef = userCollection.where('email', isEqualTo: email);
      final doc = await docRef.get();
      final data = doc.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
      print(data);
      return data.isNotEmpty;
    } catch (e) {
      print("Error getting document: $e");
      return false;
    }
  }
}