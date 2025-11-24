import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio = Dio();
  static const String _baseUrl = 'http://localhost:3000/api';

  ApiClient() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Você pode adicionar um tratamento de erro global aqui se quiser
        print('Erro na requisição: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, dynamic data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
