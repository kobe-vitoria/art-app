import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class GraphQLService extends ApiService {
  GraphQLService({
    required super.baseUrl,
    super.authToken,
    super.defaultHeaders,
  });

  Map<String, String> _buildHeaders([Map<String, String>? headers]) {
    final combined = {...defaultHeaders, ...?headers};
    if (authToken != null && authToken!.isNotEmpty) {
      combined['Authorization'] = 'Bearer $authToken';
    }
    return combined;
  }

  Future<dynamic> query(
    String query, {
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _buildHeaders(headers),
      body: jsonEncode({
        'query': query,
        if (variables != null) 'variables': variables,
      }),
    );
    return _processGraphQLResponse(response);
  }

  dynamic _processGraphQLResponse(http.Response response) {
    final body = jsonDecode(response.body);

    if (body['errors'] != null) {
      final errorMessage = body['errors'][0]['message'] ?? 'Erro GraphQL desconhecido';
      throw Exception('Erro GraphQL: $errorMessage');
    }

    return body['data'];
  }
}
