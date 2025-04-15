class UserDetails {
  final String id; // Document ID
  final String userUid;
  final String email;
  final String gender;
  final String username;

  UserDetails({
    required this.id,
    required this.userUid,
    required this.email,
    required this.gender,
    required this.username,
  });

  // Factory method to create a UserDetails object from Firestore data
  factory UserDetails.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserDetails(
      id: docId,
      userUid: data['uid'],
      email: data['email'],
      gender: data['gender'],
      username: data['username'],
    );
  }

  // Converts the UserAllergy object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': userUid,
      'email': email,
      'gender': gender,
      'username': username,
    };
  }
}
