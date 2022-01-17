import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class ResourceFilesInteractor {
  Future<String> createResourcesPathIfNotExists();

  Future<String> deleteResourcesPathIfExists();

  Future<String> getResourcesPath();
}

class ResourceFilesInteractorImpl implements ResourceFilesInteractor {
  String _resourcesPath;

  @override
  Future<String> createResourcesPathIfNotExists() async {
    String incidentsPath = await getResourcesPath();
    return await _createPathIfNotExists(incidentsPath);
  }

  @override
  Future<String> deleteResourcesPathIfExists() async {
    final directory = Directory(await getResourcesPath());
    bool exists = await directory.exists();
    if (exists) {
      await directory.delete(recursive: true);
    }
    return directory.path;
  }

  Future<String> getResourcesPath() async {
    if (_resourcesPath != null) {
      return _resourcesPath;
    } else {
      Directory directory = await getTemporaryDirectory();
      return "${directory.path}/resources";
    }
  }

  Future<String> _createPathIfNotExists(String path) async {
    final directory = Directory(path);
    bool exists = await directory.exists();
    if (!exists) {
      await directory.create(recursive: true);
    }
    return directory.path;
  }
}
