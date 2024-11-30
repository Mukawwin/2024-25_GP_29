class UserAllergy {
  final String id; // Document ID
  final String userUid;
  final String allergy_id;

  UserAllergy({
    required this.id,
    required this.userUid,
    required this.allergy_id,
  });

  // Factory method to create a UserAllergy object from Firestore data
  factory UserAllergy.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserAllergy(
      id: docId,
      userUid: data['user_uid'],
      allergy_id: data['allergy_id'],
    );
  }

  // Converts the UserAllergy object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
      'allergy_id': allergy_id,
    };
  }
}

class AllergyModel {
  final String id; // Document ID
  final String title;
  final String icon;

  AllergyModel({
    required this.id,
    required this.title,
    required this.icon,
  });

  // Factory method to create a AllergyModel object from Firestore data
  factory AllergyModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AllergyModel(
      id: docId,
      title: data['title'],
      icon: data['icon'],
    );
  }

  // Converts the UserAllergy object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
    };
  }
}
