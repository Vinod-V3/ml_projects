import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ml_projects/config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  
  ApiService._internal() {
    _dio = Dio();
    _configureInterceptors();
  }

  void _configureInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = AppConfig.instance.get('token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        final cookie = AppConfig.instance.get('cookie');
        if (cookie != null && cookie.isNotEmpty) {
          options.headers['Cookie'] = cookie;
        }

        options.headers['Content-Type'] = 'application/json';

        return handler.next(options);
      },
      onError: (error, handler) {
        debugPrint('API Error: ${error.message}');
        if (error.response != null) {
          debugPrint('Response: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));

    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  String _getFullUrl(String endpoint) {
    final baseUrl = AppConfig.instance.get('baseUrl');
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('Base URL not configured');
    }
    return '$baseUrl$endpoint';
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        _getFullUrl(endpoint),
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        _getFullUrl(endpoint),
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        _getFullUrl(endpoint),
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        _getFullUrl(endpoint),
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.patch(
        _getFullUrl(endpoint),
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception('Request timeout. Please check your internet connection.');
    } else if (e.type == DioExceptionType.badResponse) {
      return Exception(
        'Server error: ${e.response?.statusCode}. ${e.response?.data?['message'] ?? ''}',
      );
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception('No internet connection. Please check your network.');
    } else {
      return Exception('Network error: ${e.message}');
    }
  }

  void updateConfig() {
    _configureInterceptors();
  }
}
