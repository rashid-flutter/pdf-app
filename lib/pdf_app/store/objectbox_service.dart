// @Entity()
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_app/objectbox.g.dart';
import 'package:pdf_app/pdf_app/moldel/image_entity.dart';
import 'package:pdf_app/pdf_app/store/objectbox_model.dart';


class ObjectBox {
  late final Store store;
  late final Box<ImageEntity> imageBox;

  ObjectBox._create(this.store) {
    imageBox = Box<ImageEntity>(store);
  }

  static ObjectBox? _instance;

  factory ObjectBox() {
    if (_instance == null) {
      throw "ObjectBox must be initialized before use.";
    }
    return _instance!;
  }

  static Future<ObjectBox> create() async {
    if (_instance == null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final store =
          await openStore(directory: p.join(docsDir.path, "obx-example"));
      _instance = ObjectBox._create(store);
    }
    return _instance!;
  }

  static ObjectboxModel getObjectboxModel() {
    return ObjectboxModel([ImageEntity]);
  }
}
