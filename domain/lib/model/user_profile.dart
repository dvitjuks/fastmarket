import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phoneNr;
  final String? avatarUrl;
  final String? avatarFilename;
  final DateTime? creationDate;

  const UserProfile(
      {required this.userId,
        this.firstName,
        this.lastName,
        this.email,
        this.phoneNr,
        this.avatarUrl,
        this.avatarFilename,
        this.creationDate});

  UserProfile copyWith(
      {String? userId,
        String? firstName,
        String? lastName,
        String? email,
        String? phoneNr,
        String? avatarUrl,
        String? avatarFilename,
        DateTime? creationDate}) =>
      UserProfile(
          userId: userId ?? this.userId,
          firstName: firstName ?? this.firstName,
          lastName: lastName ?? this.lastName,
          email: email ?? this.email,
          phoneNr: phoneNr ?? this.phoneNr,
          avatarUrl: avatarUrl ?? this.avatarUrl,
          avatarFilename: avatarFilename ?? this.avatarFilename,
          creationDate: creationDate ?? this.creationDate);

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    email,
    phoneNr,
    avatarUrl,
    avatarFilename,
    creationDate
  ];
}
