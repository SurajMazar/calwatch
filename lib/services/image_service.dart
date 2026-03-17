import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as img;

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

class ImageService {
  static const _uuid = Uuid();

  Future<String> get _imagesDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(appDir.path, 'meal_images'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  Future<String> saveImage(String sourcePath) async {
    final dir = await _imagesDir;
    final ext = p.extension(sourcePath);
    final fileName = '${_uuid.v4()}$ext';
    final destPath = p.join(dir, fileName);

    await File(sourcePath).copy(destPath);
    return destPath;
  }

  Future<Uint8List> getCompressedImageBytes(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();

    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;

    final resized = img.copyResize(decoded, width: 1024);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
  }

  Future<Uint8List> getImageBytes(String imagePath) async {
    return File(imagePath).readAsBytes();
  }

  Future<void> deleteImage(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) await file.delete();
  }

  Future<List<String>> getAllImagePaths() async {
    final dir = Directory(await _imagesDir);
    if (!await dir.exists()) return [];
    return dir
        .listSync()
        .whereType<File>()
        .map((f) => f.path)
        .toList();
  }
}
