import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'compression_service.g.dart';

@Riverpod()
CompressionService compressionService(Ref ref) {
  return CompressionService();
}

class CompressionService {
  /// Compress image data (simplified implementation)
  /// In a real implementation, you would use packages like flutter_image_compress
  Future<Uint8List> compressImage(
    Uint8List imageData,
  ) async {
    return await FlutterImageCompress.compressWithList(
      imageData,
      minHeight: 1920,
      minWidth: 1080,
      quality: 96,
    );
  }
}
