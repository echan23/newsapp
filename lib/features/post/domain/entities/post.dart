import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String? imageURL;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    this.imageURL,
    required this.timestamp,
  });

  // copyWith method to create a new instance with modified fields
  Post copyWith({String? imageURL}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageURL: imageURL ?? this.imageURL,
      timestamp: timestamp,
    );
  }

  // Convert the Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageURL': imageURL,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create a Post object from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageURL: json['imageURL'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}
