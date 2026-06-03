sealed class PasswordResetState {
  const PasswordResetState();
}

final class PasswordResetInitial extends PasswordResetState {
  const PasswordResetInitial();
}

final class PasswordResetLoading extends PasswordResetState {
  const PasswordResetLoading();
}

final class PasswordResetEmailSent extends PasswordResetState {
  const PasswordResetEmailSent();
}

final class PasswordResetSuccess extends PasswordResetState {
  const PasswordResetSuccess();
}

final class PasswordResetError extends PasswordResetState {
  const PasswordResetError(this.mensagem);
  final String mensagem;
}
