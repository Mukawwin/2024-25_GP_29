class Save {
  final String id; // Document ID
  final String userUid;
  final String title;
  final String imagename;
  final String path;

  Save({
    required this.id,
    required this.userUid,
    required this.title,
    required this.imagename,
    required this.path,
  });

  // Factory method to create a UserAllergy object from Firestore data
  factory Save.fromFirestore(Map<String, dynamic> data, String docId) {
    return Save(
      id: docId,
      userUid: data['uid'],
      imagename: data['image'],
      title: data['title'],
      path: data['path'],
    );
  }

  get path1 => null;

  // Converts the UserAllergy object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': userUid,
      'image': imagename,
      'title': title,
      'path': path,
    };
  }
}
