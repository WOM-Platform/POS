import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerClient {
  final picker = ImagePicker();

  Future<XFile?> pickImage() async {
    if (await checkPermission()) {
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
      );
      return image;
    }
    return null;
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        return (await Permission.storage.request()).isGranted;
      }
    }
    return (await Permission.photos.request()).isGranted;
  }
}
