import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PdfService {
  static Future<File> cretePDf(List<File> images) async {
    final pdf = Document();
    for (final img in images) {
      final image = MemoryImage(File(img.path).readAsBytesSync());
      pdf.addPage(Page(build: (Context) => Center(child: Image(image))));
    }
    return await savePDF(pdf);
  }

  static Future<File> savePDF(Document pdf) async {
    var today = DateTime.now();
    final tempDir = await getTemporaryDirectory();
    final file = File(
        '${tempDir.path}/${DateTime.now().year}${today.month}${today.day}${today.hour}${today.minute}${today.second}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future sharePDF(File pdf) async {
    Share.shareXFiles([XFile(pdf.path)]);
  }
}
