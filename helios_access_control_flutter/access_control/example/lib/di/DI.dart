import 'package:access_control/access_control.dart';

import '../repository/HeliosAccessControlRepositoryImpl.dart';
import '../repository/Repository.dart';

class DI {
  static final HeliosAccessControlRepository heliosAccessControlRepository =
      HeliosAccessControlRepositoryImpl(AccessControl());
}
