import 'package:flutter/material.dart';
import 'package:newsapp2/features/auth/domain/app_user.dart';

class ProfileUser extends AppUser {
  final String bio;
  final String profileImageUrl;

  ProfileUser({
    required super.uid,
    required super.email,
    required super.name,
    required this.bio,
    required this.profileImageUrl,
  });

  //Update profile user
  ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
    return ProfileUser(
      uid: uid,
      email: email,
      name: name,
      bio: newBio ?? bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
    );
  }

  //Convert profile user to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
    };
  }

  //Convert json to profile user
  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      bio: (json['bio'] ?? '') as String,
      profileImageUrl: (json['profileImageUrl'] ?? '') as String,
    );
  }
}
