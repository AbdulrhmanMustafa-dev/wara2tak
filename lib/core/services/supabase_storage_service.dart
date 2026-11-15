import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for Supabase storage operations
class SupabaseStorageService {
  final SupabaseStorageClient _storage;

  SupabaseStorageService(this._storage);

  /// Upload a file
  Future<String> uploadFile(
    String bucket,
    String path,
    dynamic file, {
    FileOptions? fileOptions,
  }) async {
    await _storage.from(bucket).upload(
          path,
          file,
          fileOptions: fileOptions ?? const FileOptions(),
        );
    return _storage.from(bucket).getPublicUrl(path);
  }

  /// Upload binary data
  Future<String> uploadBinary(
    String bucket,
    String path,
    Uint8List bytes, {
    String? contentType,
  }) async {
    await _storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType),
        );
    return _storage.from(bucket).getPublicUrl(path);
  }

  /// Download a file
  Future<Uint8List> downloadFile(String bucket, String path) async {
    return _storage.from(bucket).download(path);
  }

  /// Get public URL for a file
  String getPublicUrl(String bucket, String path) {
    return _storage.from(bucket).getPublicUrl(path);
  }

  /// Get signed URL for private files
  Future<String> getSignedUrl(
    String bucket,
    String path, {
    int expiresIn = 3600,
  }) async {
    final response = await _storage.from(bucket).createSignedUrl(path, expiresIn);
    return response;
  }

  /// Delete a file
  Future<void> deleteFile(String bucket, String path) async {
    await _storage.from(bucket).remove([path]);
  }

  /// Delete multiple files
  Future<void> deleteFiles(String bucket, List<String> paths) async {
    await _storage.from(bucket).remove(paths);
  }

  /// List files in a bucket/folder
  Future<List<FileObject>> listFiles(String bucket, {String? path}) async {
    return _storage.from(bucket).list(path: path);
  }

  /// Move/rename a file
  Future<void> moveFile(
    String bucket,
    String fromPath,
    String toPath,
  ) async {
    await _storage.from(bucket).move(fromPath, toPath);
  }

  /// Copy a file
  Future<void> copyFile(
    String bucket,
    String fromPath,
    String toPath,
  ) async {
    await _storage.from(bucket).copy(fromPath, toPath);
  }

  /// Get file metadata
  Future<FileObject?> getFileInfo(String bucket, String path) async {
    final files = await _storage.from(bucket).list(path: path);
    if (files.isEmpty) return null;
    return files.firstWhere((f) => f.name == path.split('/').last);
  }

  /// Create a bucket (admin only)
  Future<void> createBucket(
    String bucket, {
    bool public = false,
    String? fileSizeLimit,
    List<String>? allowedMimeTypes,
  }) async {
    await _storage.createBucket(
      bucket,
      BucketOptions(
        public: public,
        fileSizeLimit: fileSizeLimit,
        allowedMimeTypes: allowedMimeTypes,
      ),
    );
  }

  /// Delete a bucket (admin only)
  Future<void> deleteBucket(String bucket) async {
    await _storage.deleteBucket(bucket);
  }

  /// Empty a bucket (delete all files)
  Future<void> emptyBucket(String bucket) async {
    final files = await listFiles(bucket);
    if (files.isNotEmpty) {
      final paths = files.map((f) => f.name).toList();
      await deleteFiles(bucket, paths);
    }
  }
}