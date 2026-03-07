import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final bool isAnonymous;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.isAnonymous = false,
  });

  @override
  List<Object?> get props => [id, email, displayName, isAnonymous];
}