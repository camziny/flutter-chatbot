class AuthProvider extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  UserSession? _session;
  String? _rawSession;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  UserSession? get session => _session;
  String? get rawSession => _rawSession;

  Future<void> init() async {
    final rawSession = await _storage.read(key: 'session');
    if (rawSession != null) {
      try {
        final sessionData = json.decode(rawSession);
        _session = UserSession.fromJson(sessionData);
        _rawSession = rawSession;
        _isAuthenticated = true;
      } catch (e) {
        await clearSession();
      }
    }
    notifyListeners();
  }

  Future<void> setSession(UserSession session, String rawSession) async {
    await _storage.write(key: 'session', value: rawSession);
    _session = session;
    _rawSession = rawSession;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> clearSession() async {
    await _storage.delete(key: 'session');
    _session = null;
    _rawSession = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}