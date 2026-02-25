import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Authenticated user of the application.
///
/// Contains basic identity information. Authentication state
/// is managed separately by the auth cubit/service, not stored
/// on this entity.
@JsonSerializable()
class User extends Equatable {
  const User({
    required this.email,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// User's email address.
  final String email;

  /// User's display name.
  final String name;

  @override
  List<Object?> get props => [email, name];
}
