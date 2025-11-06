import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String? authToken;
  final Map<String, String> defaultHeaders;

  ApiService({
    required this.baseUrl,
    this.authToken,
    this.defaultHeaders = const {'Content-Type': 'application/json'},
  });

  Map<String, String> _buildHeaders([Map<String, String>? headers]) {
    final combined = {...defaultHeaders, ...?headers};
    if (authToken != null && authToken!.isNotEmpty) {
      combined['Authorization'] = 'Bearer $authToken';
    }
    return combined;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, dynamic data, {Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(headers),
    );
    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    final status = response.statusCode;

    if (status == 401) {
      throw Exception('Não autorizado (401): token inválido ou expirado.');
    } else if (status >= 200 && status < 300 || status == 304) {
      return response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } else {
      throw Exception(
        'Erro na requisição (${response.statusCode}): ${response.body}',
      );
    }
  }
}
