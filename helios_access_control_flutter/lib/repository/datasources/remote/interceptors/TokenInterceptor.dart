import 'package:dio/dio.dart';
import 'package:helios_access_control_ui/repository/datasources/preferences/Settings.dart';

class TokenInterceptor extends InterceptorsWrapper {
  final Settings _settings;

  TokenInterceptor(this._settings);

  @override
  Future onRequest(RequestOptions options) async {
    if (options.headers.containsKey("requiresToken")) {
      //remove the auxiliary header
      options.headers.remove("requiresToken");

      var userToken = _settings.getUserToken();
      options.headers["Authorization"] = "Bearer $userToken";

      return options;
    }
  }
}
