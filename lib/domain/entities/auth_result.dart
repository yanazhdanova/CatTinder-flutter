import 'package:equatable/equatable.dart';
import 'user.dart';

abstract class AuthResult extends Equatable {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthResult {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoading extends AuthResult {
  const AuthLoading();

  @override
  List<Object?> get props => [];
}