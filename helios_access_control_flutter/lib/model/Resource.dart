import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:helios_access_control_ui/model/Content.dart';
import 'package:video_compress/video_compress.dart';
import 'package:path/path.dart' as pathUtils;

class Resource {
  String localPath;

  Resource({this.localPath});

  bool isAccessible() {
    return localPath != null;
  }

  static Resource notAccessible() {
    return Resource();
  }
}

class UploadResource {
  String title;
  PlatformFile platformFile;
  String pathPreview;
  AccessType accessType;
  String groupId;

  UploadResource({
    this.title,
    this.platformFile,
    this.pathPreview,
    this.accessType,
    this.groupId
  });

  String get fileName => platformFile != null ? platformFile.name : null;

  String get path => platformFile != null ? platformFile.path : null;

  UploadResource copyWith(
      {String title, PlatformFile platformFile, String pathPreview}) {
    return UploadResource(
      title: title ?? this.title,
      platformFile: platformFile ?? this.platformFile,
      pathPreview: pathPreview ?? this.pathPreview,
    );
  }
  
  bool hasImagePreview() {
    return (fileName != null) && (isImage() || isVideo());
  }

  bool hasTextPreview() {
    return (fileName != null) && (isDocument());
  }

  bool isImage() {
    return fileName.endsWith(".jpg") ||
        fileName.endsWith(".jpeg") ||
        fileName.endsWith(".png");
  }

  bool isVideo() {
    //TODO Find a better way to do it
    return fileName.endsWith(".webm") ||
        fileName.endsWith(".mpg") ||
        fileName.endsWith(".mp2") ||
        fileName.endsWith(".mpeg") ||
        fileName.endsWith(".mpe") ||
        fileName.endsWith(".mpv") ||
        fileName.endsWith(".ogg") ||
        fileName.endsWith(".mp4") ||
        fileName.endsWith(".m4p") ||
        fileName.endsWith(".m4v") ||
        fileName.endsWith(".avi") ||
        fileName.endsWith(".wmv") ||
        fileName.endsWith(".mov") ||
        fileName.endsWith(".qt") ||
        fileName.endsWith(".flv") ||
        fileName.endsWith(".swf") ||
        fileName.endsWith(".avchd");
  }

  bool isDocument() {
    //TODO Find a better way to do it
    return fileName.endsWith(".doc") ||
        fileName.endsWith(".docx") ||
        fileName.endsWith(".html") ||
        fileName.endsWith(".htm") ||
        fileName.endsWith(".odt") ||
        fileName.endsWith(".pdf") ||
        fileName.endsWith(".xls") ||
        fileName.endsWith(".xlsx") ||
        fileName.endsWith(".ods") ||
        fileName.endsWith(".ppt") ||
        fileName.endsWith(".pptx") ||
        fileName.endsWith(".txt");
  }

  bool isValid() {
    return (title != null && title.isNotEmpty) &&
        (path != null && path.isNotEmpty);
  }

  Future<void> generatePreview() async {
    if (isImage()) {
      this.pathPreview = this.path;
    } else if (isVideo()) {
      File thumbnailFile = await VideoCompress.getFileThumbnail(path,
          quality: 50, // default(100)
          position: -1 // default(-1)
          );
      this.pathPreview = thumbnailFile.path;
    } else if (isDocument()) {
      this.pathPreview = pathUtils.basename(path);
    }
  }
}
