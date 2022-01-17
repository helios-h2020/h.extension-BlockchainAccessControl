import 'package:dio/dio.dart';
import 'package:helios_access_control_ui/repository/datasources/preferences/Settings.dart';
import 'package:helios_access_control_ui/repository/datasources/remote/interceptors/TokenInterceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  Dio _dio;

  DioClient(Settings settings) {
    _dio = Dio();
    _dio.interceptors.add(TokenInterceptor(settings));
    _dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
    );
  }

  void setTimeout(Duration duration) {
    _dio.options.connectTimeout = duration.inMilliseconds;
    _dio.options.receiveTimeout = duration.inMilliseconds;
    _dio.options.sendTimeout = duration.inMilliseconds;
  }

  Future<Response> get(String url, {Options options, Map<String, dynamic> queryParameters}) async {
    return await _dio.get(
      url,
      options: options,
      queryParameters: queryParameters,
    );
  }

  Future<Response> download(String url, String savePath, {Options options}) async {
    return await _dio.download(
      url,
      savePath,
      options: options,
    );
  }

  Future<Response> post(String url, {body, Options options}) async {
    return await _dio.post(url, data: body, options: options);
  }

  Future<Response> put(String url, {body, Options options}) async {
    return await _dio.put(url, data: body, options: options);
  }

  Future<Response> delete(String url, {body, Options options}) async {
    return await _dio.delete(url, data: body, options: options);
  }
}

abstract class NetworkError {}

class TimeOutError extends NetworkError {}

class ResponseError extends NetworkError {}

class NoInternetError extends NetworkError {}

class DefaultError extends NetworkError {}
