import 'package:cloud_firestore/cloud_firestore.dart';

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

class Expiration {
  final String id; // Document ID
  final String userUid;
  final String title;
  final String imagename;
  final String path;
  final Timestamp date;

  Expiration(
      {required this.id,
      required this.userUid,
      required this.title,
      required this.imagename,
      required this.path,
      required this.date});

  // Factory method to create a UserAllergy object from Firestore data
  factory Expiration.fromFirestore(Map<String, dynamic> data, String docId) {
    return Expiration(
      id: docId,
      userUid: data['uid'],
      imagename: data['image'],
      title: data['title'],
      path: data['path'],
      date: data['date'],
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
      'date': date,
    };
  }
}

class Incidentlog {
  final String id; // Document ID
  final String userUid;
  final String title;
  final String imagename;
  final Timestamp date;
  final String desc;
  final String path;

  Incidentlog(
      {required this.id,
      required this.userUid,
      required this.title,
      required this.imagename,
      required this.date,
      required this.desc,
      required this.path});

  // Factory method to create a UserAllergy object from Firestore data
  factory Incidentlog.fromFirestore(Map<String, dynamic> data, String docId) {
    return Incidentlog(
      id: docId,
      userUid: data['uid'],
      imagename: data['image'],
      title: data['title'],
      date: data['date'],
      desc: data['desc'],
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
      'date': date,
      'desc': desc,
      'path': path,
    };
  }
}
