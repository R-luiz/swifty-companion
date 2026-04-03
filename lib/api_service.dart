import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  static const String _baseUrl = 'https://api.intra.42.fr';
  String? _accessToken;
  DateTime? _tokenExpiry;

  Future<void> _authenticate() async {
    final uid = dotenv.env['API_UID'];
    final secret = dotenv.env['API_SECRET'];
    if (uid == null || secret == null) {
      throw Exception('Missing .env credentials');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/oauth/token'),
      body: {
        'grant_type': 'client_credentials',
        'client_id': uid,
        'client_secret': secret,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Auth failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    _accessToken = data['access_token'];
    final expiresIn = data['expires_in'] as int;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 90));
  }

  Future<void> _ensureToken() async {
    if (_accessToken == null ||
        _tokenExpiry == null ||
        DateTime.now().isAfter(_tokenExpiry!)) {
      await _authenticate();
    }
  }

  Future<UserProfile> fetchUser(String login) async {
    await _ensureToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/v2/users/$login'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 404) {
      throw UserNotFoundException('$login not found');
    }
    if (response.statusCode == 401) {
      _accessToken = null; // force re-auth
      await _ensureToken();
      return fetchUser(login);
    }
    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    return UserProfile.fromJson(data);
  }
}

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException(this.message);

  @override
  String toString() => message;
}
