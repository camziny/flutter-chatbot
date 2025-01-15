class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();
  final AuthProvider _authProvider;

  AuthenticatedHttpClient(this._authProvider);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_authProvider.rawSession != null) {
      request.headers['Cookie'] = 'next-auth.session-token=${_authProvider.rawSession}';
    }
    return _inner.send(request);
  }

  void close() {
    _inner.close();
  }
}