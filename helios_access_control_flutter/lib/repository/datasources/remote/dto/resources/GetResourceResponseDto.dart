import 'dart:typed_data';

import 'package:helios_access_control_ui/model/Resource.dart';

class GetResourceResponseDto {

  String localPath;

  GetResourceResponseDto({
    this.localPath,
  });

  Resource toModel() {
    return Resource(localPath: localPath);
  }
}
