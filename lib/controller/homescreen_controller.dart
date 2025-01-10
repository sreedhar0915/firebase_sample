import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class HomescreenController with ChangeNotifier {
  String imageurl = "";
  static final studentcollection =
      FirebaseFirestore.instance.collection('students');
  static Future<void> deletedata(String id) async {
    await studentcollection.doc(id).delete();
  }

  static Future<void> adddata({
    required Map<String, dynamic> data,
  }) async {
    await studentcollection.add(data);
  }

  static Future<void> editdata({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await studentcollection.doc(id).update(data);
  }

  picker() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagepicker =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagepicker != null) {
      log(imagepicker.path);
      // upload to firebase storage
      // points to the root reference
      final storageref = FirebaseStorage.instance.ref();
      // Points to folder - june
      Reference? folderRef = storageref.child("june");
// creating a image file name
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final fileRef = folderRef.child("$fileName.jpg");
      // upload image to file reference

      await fileRef.putFile(File(imagepicker.path));

      // get download url
      var downloadUrl = await fileRef.getDownloadURL();
      log(downloadUrl.toString());
    }
  }
}
 //String name, String subject