/*

Profile states

*/

import 'package:newsapp2/features/profile/domain/profile_user.dart';

abstract class ProfileState {}

//Initial
class ProfileInitial extends ProfileState {}

//Loading
class ProfileLoading extends ProfileState {}

//Loaded
class ProfileLoaded extends ProfileState {
  final ProfileUser profileUser;
  ProfileLoaded(this.profileUser);
}

//Error
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
