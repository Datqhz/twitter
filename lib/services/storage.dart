import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class Storage{

  final avatarRef = FirebaseStorage.instance.ref().child("avatar");
  final wallRef = FirebaseStorage.instance.ref().child("wall");
  final tweetImgRef = FirebaseStorage.instance.ref().child("tweet/images");
  final tweetVideoRef = FirebaseStorage.instance.ref().child("tweet/video");

  Future<String?> downloadAvatarURL(String link) async {
    try {
      // Download the image to memory
      Reference storageReference = avatarRef.child(link);

      // Get the download URL for the image
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print("Cannot download file from Firebase Storage: $e");
      return null;
    }
  }

  Future<String> getImageTweetURL(String imageUrl) async {
    // Get the reference to the Firebase Storage image
    Reference storageReference = tweetImgRef.child(imageUrl);

    // Get the download URL for the image
    String downloadURL = await storageReference.getDownloadURL();

    return downloadURL;
  }
  Future<Uint8List> getVideoTweetUint8List(String videoUrl) async {
    // Get the reference to the Firebase Storage image
    Reference storageReference = tweetVideoRef.child(videoUrl);

    // Get the download URL for the image
    String downloadURL = await storageReference.getDownloadURL();

    // Fetch the image bytes using http
    final response = await get(Uri.parse(downloadURL));

    if (response.statusCode == 200) {
      // Convert the response body (bytes) to Uint8List
      return Uint8List.fromList(response.bodyBytes);
    } else {
      throw Exception('Failed to load image');
    }
  }
  Future<String?> downloadWallULR(String link) async {
    try {
      // Download the image to memory
      Reference storageReference = wallRef.child(link);

      // Get the download URL for the image
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print("Cannot download file from Firebase Storage: $e");
      return null;
    }
  }
  Future<String> putImage(XFile image)async{
    try{
      String randomName = getRandomString(10);
      tweetImgRef.child(randomName+".jpg").putFile(File(image.path));
      return randomName+".jpg";
    }catch(e){
      return "";
    }
  }
  String getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
  Storage();
}