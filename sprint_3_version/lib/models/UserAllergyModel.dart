class UserAllergy {
  final String id; // Document ID
  final String userUid;
  final String allergie;

  UserAllergy({
    required this.id,
    required this.userUid,
    required this.allergie,
  });

  // Factory method to create a UserAllergy object from Firestore data
  factory UserAllergy.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserAllergy(
      id: docId,
      userUid: data['user_uid'],
      allergie: data['allergie'],
    );
  }

  // Converts the UserAllergy object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'allergie': allergie,
    };
  }
}
