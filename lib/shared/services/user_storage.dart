import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class UserStorage {
  StorageReference userPicturesReferences =
      FirebaseStorage.instance.ref().child("userPictures");

  Future<String> uploadFile(String userEmail, File image) async {
    final pictureId = Uuid().v4();
    StorageReference storageReference =
        userPicturesReferences.child("$userEmail/$pictureId.jpg");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final String url = await storageReference.getDownloadURL();
    return url;
  }

  Future<List<String>> uploadBatchOfImagesInFileFormat(
      String userEmail, List<File> images) async {
    final List<String> futures = [];
    for (var image in images) {
      futures.add(await uploadFile(userEmail, image));
    }
    return futures;
  }

  Future<List<String>> uploadBatchOfImagesInAssetFormat(
      String userEmail, List<Asset> images) async {
    final List<String> futures = [];

    for (var image in images) {
      ByteData byteData = await image.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      final pictureId = Uuid().v4();
      final StorageReference storageReference =
          userPicturesReferences.child("$userEmail/$pictureId.jpg");

      StorageUploadTask uploadTask = storageReference.putData(imageData);
      await uploadTask.onComplete;
      final String url = await storageReference.getDownloadURL();
      futures.add(url);
    }

    return futures;
  }
}
