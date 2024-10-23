class UserAllergy {
  final String id; 
  final String userUid;
  final String allergie;

  UserAllergy({
    required this.id,
    required this.userUid,
    required this.allergie,
  });

  factory UserAllergy.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserAllergy(
      id: docId,
      userUid: data['user_uid'],
      allergie: data['allergie'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'allergie': allergie,
    };
  }
}
