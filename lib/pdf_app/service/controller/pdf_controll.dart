import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_app/objectbox.g.dart';
import 'package:pdf_app/pdf_app/moldel/image_entity.dart';
import 'package:pdf_app/pdf_app/service/image_service.dart';
import 'package:pdf_app/pdf_app/store/objectbox_service.dart';

class ImageNotifer extends StateNotifier<List<File>> {
  late final ObjectBox objectBox;
  ImageNotifer() : super([]) {
    objectBox = ObjectBox();
    state = getImagesFromBox();
  }
  //getv all image in db
  List<File> getImagesFromBox() {
    final imageEntities = objectBox.imageBox.getAll();
    return imageEntities.map((entity) => File(entity.imagePath)).toList();
  }

  //image save in db
  void saveImageToBox(String imagePath) {
    final imageEntity = ImageEntity(imagePath);
    objectBox.imageBox.put(imageEntity);
    state = getImagesFromBox();
  }

  //delete image full
  void deleteImage(int index) {
    if (index >= 0 && index < state.length) {
      final imageFile = state[index];
      final imageEntity = objectBox.imageBox
          .query(ImageEntity_.imagePath.equals(imageFile.path))
          .build()
          .findFirst();
      if (imageEntity != null) {
        objectBox.imageBox.remove(imageEntity.id);
        state = getImagesFromBox();
      }
    }
  }

  //open camera
  Future<void> openCamera() async {
    final capturedImage = await ImageService.captureImage();
    if (capturedImage != null) {
      final croppedImage = await ImageService.cropImage(capturedImage);
      if (croppedImage != null) {
        saveImageToBox(croppedImage.path);
      }
    }
  }

//open gallery
  Future<void> openGallery() async {
    final selectedImage = await ImageService.selectImage();
    if (selectedImage != null) {
      final croppedImage = await ImageService.cropImage(selectedImage);
      if (croppedImage != null) {
        saveImageToBox(croppedImage.path);
      }
    }
  }

  //drag and posision change
  void reorderimages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = state.removeAt(oldIndex);
    state.insert(newIndex, item);
  }

  //delete all image in dd....
  void deleteAllImages() {
    objectBox.imageBox.removeAll();
    state = [];
  }
}

final imageProvider =
    StateNotifierProvider<ImageNotifer, List<File>>((ref) => ImageNotifer());
