import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UserStorage {
  uploadFile(String userEmail, File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("userPictures/$userEmail");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    return uploadTask.onComplete;
  }
}
