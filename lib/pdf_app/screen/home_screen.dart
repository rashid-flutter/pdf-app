import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_app/pdf_app/moldel/image_entity.dart';
import 'package:pdf_app/pdf_app/screen/pdf_view_screen.dart';
import 'package:pdf_app/pdf_app/service/image_service.dart';
import 'package:pdf_app/pdf_app/service/pdf_service.dart';
import 'package:pdf_app/pdf_app/store/objectbox_service.dart';
// import 'package:objectbox/objectbox.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> images = [];
  List<File> storedImages = [];
  // save imges in database
  void savaImageToBox(String imagePath) {
    final imageEntity = ImageEntity(imagePath);
    final objectBox = ObjectBox(); // Change this line

    objectBox.imageBox.put(imageEntity);
    setState(() {
      images.add(File(imagePath));
    });
  }

  //get all images in db
  List<File> getImagesFromBox() {
    final objectBox = ObjectBox(); // Change this line
    final imageEntities = objectBox.imageBox.getAll();
    return imageEntities.map((entity) => File(entity.imagePath)).toList();
  }

  void openCamera() async {
    final capturedImage = await ImageService.captureImage();
    if (capturedImage != null) {
      final croppedImage = await ImageService.cropImage(capturedImage);
      if (croppedImage != null) {
        savaImageToBox(croppedImage.path);
      }
    }
  }

  void openGallery() async {
    final selectedImage = await ImageService.selectImage();
    if (selectedImage != null) {
      final croppedImage = await ImageService.cropImage(selectedImage);
      if (croppedImage != null) {
        savaImageToBox(croppedImage.path);
      }
    }
  }

  void deleteImage(int index) {
    setState(() {
      if (index >= 0 && index < storedImages.length) {
        storedImages.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<File> storedImages = getImagesFromBox();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Flutter Pdf Creator',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: openCamera,
            child: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: openGallery,
            child: const Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: storedImages.isEmpty
          ? Center(
              child: Text(
                'Choose Images to create pdf',
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: storedImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => Stack(
                children: [
                  Image.file(
                    storedImages[index],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          // storedImages.removeAt(index);
                          deleteImage(index);
                        });
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: storedImages.isEmpty
                ? () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please pick some images',
                          style:
                              TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                    );
                  }
                : () async {
                    final createdPdf = await PdfService.cretePDf(storedImages);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewPdfScreen(pdf: createdPdf)));
                  },
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color.fromARGB(255, 255, 246, 246),
            ),
          ),
        ],
      ),
    );
  }
}
