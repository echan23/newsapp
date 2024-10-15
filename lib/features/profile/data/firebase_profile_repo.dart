import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp2/features/profile/domain/profile_user.dart';
import 'package:newsapp2/features/profile/domain/repos/profile_repo.dart';

class FirebaseProfileRepo extends ProfileRepo {
  final FirebaseFirestore userDatabase = FirebaseFirestore.instance;

  @override
  Future<ProfileUser?> fetchUserProfile(String uid) async {
    try {
      // Get user document from Firestore
      final userDoc = await userDatabase.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();

        if (userData != null) {
          // Create and return a ProfileUser object from the fetched data
          return ProfileUser(
            uid: userData['uid'] ?? '', // Corrected field assignment
            email: userData['email'] ?? '',
            name: userData['name'] ?? '',
            bio: userData['bio'] ?? '',
            profileImageUrl: userData['profileImageURL']?.toString() ?? '',
          );
        }
      }
      // Return null if the document doesn't exist or has no data
      return null;
    } catch (e) {
      // Log the error (optional) and return null
      print('Error fetching user profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateProfile(ProfileUser updatedProfile) async {
    try {
      // Convert the updated profile to JSON
      final profileData = updatedProfile.toJson();

      // Update the user document in Firestore
      await userDatabase.collection('users').doc(updatedProfile.uid).update({
        'bio': updatedProfile.bio,
        'profileImageUrl': updatedProfile.profileImageUrl,
      });

      print('User profile updated successfully');
    } catch (e) {
      // Handle errors (e.g., network issues or permissions)
      print('Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }
}
