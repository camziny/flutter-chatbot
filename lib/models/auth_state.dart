enum AuthStatus {
  idle,
  inProgress,
  success,
  failed,
  userExists,
  invalidData
}

class AuthState {
  final AuthStatus status;
  final String? error;

  AuthState({
    this.status = AuthStatus.idle,
    this.error,
  });
}