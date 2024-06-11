// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_app/pdf_app/screen/pdf_view_screen.dart';
import 'package:pdf_app/pdf_app/service/controller/pdf_controll.dart';
import 'package:pdf_app/pdf_app/service/image_service.dart';
import 'package:pdf_app/pdf_app/service/pdf_service.dart';
// import 'package:pdf_app/pdf_app/store/objectbox_service.dart';
// import 'package:pdf_app/main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storedImages = ref.watch(imageProvider);
    final imageNotifier = ref.read(imageProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'PDF Creator',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: imageNotifier.openCamera,
            icon: const Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          IconButton(
            onPressed: imageNotifier.openGallery,
            icon: const Icon(
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
                  GestureDetector(
                    onTap: () async {
                      final croppedImage =
                          await ImageService.cropImage(storedImages[index]);
                      if (croppedImage != null) {
                        imageNotifier.deleteImage(index);
                        imageNotifier.saveImageToBox(croppedImage.path);
                      }
                    },
                    child: Image.file(
                      storedImages[index],
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        imageNotifier.deleteImage(index);
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
                        builder: (context) => ViewPdfScreen(pdf: createdPdf),
                      ),
                    );
                  },
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color.fromARGB(255, 255, 246, 246),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: storedImages.isEmpty
                ? null
                : () {
                    imageNotifier.deleteAllImages();
                  },
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 255, 246, 246),
            ),
          ),
        ],
      ),
    );
  }
}
