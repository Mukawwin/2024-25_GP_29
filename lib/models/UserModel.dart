class UserModel {
  final String userUid;
  final String email;
  final String username;

  UserModel({
    required this.userUid,
    required this.email,
    required this.username,
  });

  // Factory method to create a UserModel object from Firestore data
  factory UserModel.fromFirestore(
    Map<String, dynamic> data,
  ) {
    return UserModel(
      userUid: data['uid'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
