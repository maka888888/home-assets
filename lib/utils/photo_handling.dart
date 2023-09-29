import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<String?> uploadPicture(BuildContext context, ImageSource source) async {
  var uuid = const Uuid();
  String fileName = uuid.v1();
  final ImagePicker picker = ImagePicker();
  XFile? image;

  try {
    image = await picker.pickImage(
      source: source,
      maxHeight: 1000,
      maxWidth: 1000,
    );
  } catch (e) {
    print(e);
  }

  if (image == null) {
    return null;
  } else {
    await FirebaseStorage.instance.ref('pictures/$fileName.jpg').putData(
        await image.readAsBytes(), SettableMetadata(contentType: 'image/jpg'));

    String url = await FirebaseStorage.instance
        .ref('pictures/$fileName.jpg')
        .getDownloadURL();

    return url;
  }
}

Future<void> deletePhoto(BuildContext context, String url) async {
  Reference ref = FirebaseStorage.instance.refFromURL(url);
  try {
    ref.delete();
  } catch (e) {
    print(e);
  }
}
