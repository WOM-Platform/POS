import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pos/src/my_logger.dart';

final selectedImageProvider = StateProvider.autoDispose<Uint8List?>((ref) {
  return null;
});

final croppedDataProvider = StateProvider.autoDispose<Uint8List?>((ref) {
  return null;
});

final cropControllerProvider = Provider.autoDispose<CropController>((ref) {
  final c = CropController();
  return c;
});

enum CropType { square, circle }

class AddImageScreen extends HookConsumerWidget {
  final String? imageUrl;
  final CropType cropType;
  final int minWidth;
  final int minHeight;
  final Future Function(Uint8List)? onSave;

  const AddImageScreen({
    Key? key,
    this.imageUrl,
    this.onSave,
    this.minWidth = 1024,
    this.minHeight = 1024,
    this.cropType = CropType.square,
  }) : super(key: key);

  Future pickImage(WidgetRef ref, ValueNotifier<bool> isProcessing) async {
    isProcessing.value = true;
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        // maxHeight: 1024
      );

      if (image == null) return;
      final bytes = await image.readAsBytes();
      ref.read(selectedImageProvider.notifier).state = bytes;
      isProcessing.value = false;
    } catch (ex) {
      isProcessing.value = false;
      logger.e(ex);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = ref.watch(selectedImageProvider);
    final croppedData = ref.watch(croppedDataProvider);
    final cropController = ref.watch(cropControllerProvider);
    final isProcessing = useState(false);

    return Scaffold(
      appBar: AppBar(
        title:
            Text(imageUrl != null ? 'Modifica immagine' : 'Aggiungi immagine'),
      ),
      body: LoadingOverlay(
        isLoading: isProcessing.value,
        child: selectedImage == null
            ? imageUrl != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(imageUrl: imageUrl!),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () async {
                            await pickImage(ref, isProcessing);
                          },
                          child: Text('Modifica'),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await pickImage(ref, isProcessing);
                      },
                      child: Text('Seleziona immagine'),
                    ),
                  )
            : croppedData != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Image.memory(croppedData),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              isProcessing.value = true;
                              final result =
                                  await FlutterImageCompress.compressWithList(
                                croppedData,
                                minHeight: minHeight,
                                minWidth: minWidth,
                                quality: 80,
                              );
                              print(croppedData.length);
                              print(result.length);

                              await onSave?.call(result);
                              Navigator.of(context).pop();
                            } catch (ex) {
                              logger.e(ex);
                              isProcessing.value = false;
                            }
                          },
                          child: Text('Salva'),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned.fill(
                        child: Crop(
                          image: selectedImage,
                          aspectRatio: 1.0,
                          // radius: cropType == CropType.circle ? 100 : 0,
                          controller: cropController,
                          onCropped: (image) {
                            ref.read(croppedDataProvider.notifier).state =
                                image;
                            isProcessing.value = false;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            isProcessing.value = true;
                            cropController.crop();
                            // if (cropType == CropType.circle) {
                            // } else {
                            //   cropController.cropCircle();
                            // }
                          },
                          child: Text('Crop'),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
