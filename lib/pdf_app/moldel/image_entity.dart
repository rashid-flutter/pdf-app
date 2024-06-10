import 'package:objectbox/objectbox.dart';

@Entity()
class ImageEntity {
  int id = 0;
  String imagePath;
  ImageEntity(this.imagePath);
}
