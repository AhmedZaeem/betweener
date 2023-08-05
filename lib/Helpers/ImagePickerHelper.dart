import 'dart:io';

import 'package:image_picker/image_picker.dart';

mixin ImagePickerHelper {
  Future<File?> pickImage({bool fromCamera = false}) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
}
