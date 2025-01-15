import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final AuthProvider _authProvider;
  final String baseUrl = 'YOUR_NEXTJS_URL';
  
  AuthService(this._authProvider);

  Future<AuthState> login(String email, String password) async {
    try {
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
        return AuthState(status: AuthStatus.invalidData);
      }
      if (password.length < 6) {
        return AuthState(status: AuthStatus.invalidData);
      }

      final csrfResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/csrf'),
      );
      final csrfToken = json.decode(csrfResponse.body)['csrfToken'];

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/callback/credentials'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
        },
        body: json.encode({
          'email': email,
          'password': password,
          'redirect': false,
          'callbackUrl': '$baseUrl',
        }),
      );

      if (response.statusCode == 200) {
        final sessionResponse = await http.get(
          Uri.parse('$baseUrl/api/auth/session'),
        );
        
        if (sessionResponse.statusCode == 200) {
          final sessionData = json.decode(sessionResponse.body);
          final session = UserSession.fromJson(sessionData);
          
          await _authProvider.setSession(
            session,
            sessionResponse.body,
          );
          return AuthState(status: AuthStatus.success);
        }
      }
      return AuthState(status: AuthStatus.failed);
    } catch (e) {
      print('Login error: $e');
      return AuthState(
        status: AuthStatus.failed,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    try {
      await http.post(Uri.parse('$baseUrl/api/auth/signout'));
      await _authProvider.clearSession();
    } catch (e) {
      print('Logout error: $e');
      await _authProvider.clearSession();
    }
  }
}