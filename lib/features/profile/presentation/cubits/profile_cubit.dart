import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp2/features/profile/domain/profile_user.dart';
import 'package:newsapp2/features/profile/domain/repos/profile_repo.dart';
import 'package:newsapp2/features/profile/presentation/cubits/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  // Fetch user profile from Firestore
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading()); // Emit loading state
      final profile = await profileRepo.fetchUserProfile(uid);
      if (profile != null) {
        emit(ProfileLoaded(profile)); // Emit loaded state with profile data
      } else {
        emit(ProfileError('User not found')); // Emit error if profile is null
      }
    } catch (e) {
      emit(ProfileError(
          'Failed to load profile: $e')); // Emit error on exception
    }
  }

  // Update user profile in Firestore
  Future<void> updateUserProfile({required String uid, String? newBio}) async {
    try {
      emit(ProfileLoading()); // Emit loading state
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError('Error fetching user for profile update'));
        return;
      }

      //Updated profile
      final updatedProfile = currentUser.copyWith(newBio: newBio ?? currentUser.bio);

      await profileRepo.updateProfile(updatedProfile); 

      emit(ProfileLoaded(updatedProfile)); // Emit loaded state with updated profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Failed to update profile: $e')); // Emit error on exception
    }
  }
}
