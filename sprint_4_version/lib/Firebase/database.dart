import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mukawwin_3/models/UserAllergyModel.dart';
import 'package:mukawwin_3/models/getuserdetails.dart';
import 'package:mukawwin_3/models/save.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all allergies for a specific user by user_uid
  Future<List<UserAllergy>> getUserAllergies() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_auth.currentUser!.uid)
          .where('user_uid', isEqualTo: _auth.currentUser!.uid)
          .get();

      print('+++++++++++++++++++++++++++++++++++++++++++++++++++++');
      if (snapshot.docs.isEmpty) {
        print('++++++++++++++++111111111111111111111++++++++++++++++');
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserAllergy.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching user allergies: $e');
      rethrow;
    }
  }

  Future<List<UserAllergy>> getAllergies(String name) async {
    try {
      print(name);
      QuerySnapshot snapshot = await _firestore
          .collection(_auth.currentUser!.uid)
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserAllergy.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching user allergies: $e');
      rethrow;
    }
  }

  Future<List<Save>> getsaveList(String name) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) =>
                Save.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching : $e');
      rethrow;
    }
  }

  Future<List<Save>> getsaveformList(String name) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .where((doc) {
              var data = doc.data() as Map<String, dynamic>?; // تحويل آمن
              return data != null &&
                  !data.containsKey('date'); // التحقق من وجود 'date'
            })
            .map((doc) =>
                Save.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching : $e');
      rethrow;
    }
  }

  Future<List<Expiration>> getExpirationList(String name) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('savelist${_auth.currentUser!.uid}')
          .where('name', isEqualTo: name)
          .get(); // لا نستخدم where('date', isGreaterThan: null)

      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .where((doc) {
              var data = doc.data() as Map<String, dynamic>?; // تحويل آمن
              return data != null &&
                  data.containsKey('date'); // التحقق من وجود 'date'
            })
            .map((doc) => Expiration.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  Future<List<Incidentlog>> getIncidentlogList(String name) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('incidents${_auth.currentUser!.uid}')
          .where('name', isEqualTo: name)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => Incidentlog.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching data: $e');
      rethrow;
    }
  }

  Future<List<UserDetails>> getuserdetails() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('uid', isEqualTo: _auth.currentUser!.uid)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserDetails.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching : $e');
      rethrow;
    }
  }

  // Add a new allergy for a user
  Future<void> addUserAllergy(String allergy, String name, String email,
      String gender, String id) async {
    try {
      await _firestore.collection(_auth.currentUser!.uid).add({
        "allergie": allergy,
        "user_uid": id,
        "gender": gender,
        "name": name,
        "email": email
      });
      print('Allergy added successfully!');
    } catch (e) {
      print('Error adding allergy: $e');
      rethrow;
    }
  }

  Future<List<UserAllergy>> getAllergyFromName(String name) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_auth.currentUser!.uid)
          .where('name', isEqualTo: name)
          .get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserAllergy.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching : $e');
      rethrow;
    }

    // print("UOD; ${_auth.currentUser!.uid}");
    // QuerySnapshot snapshot = await _firestore
    //     .collection(_auth.currentUser!.uid)
    //     // .where("user_uid", isEqualTo: _auth.currentUser!.uid)
    //     // .where("name", isEqualTo: name)
    //     .get();
    // if (snapshot.docs.isNotEmpty) {
    //   print("yyyye");
    //   return UserAllergy.fromFirestore(
    //       snapshot.docs.first.data() as Map<String, dynamic>,
    //       snapshot.docs.first.id);
    // } else {
    //   return null;
    // }
  }

  Future<List<UserAllergy>> getalluser() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_auth.currentUser!.uid).get();
      if (snapshot.docs.isEmpty) {
        return [];
      } else {
        return snapshot.docs
            .map((doc) => UserAllergy.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      print('Error fetching : $e');
      rethrow;
    }
  }

  // Delete an allergy using the document ID
  Future<void> deleteUserAllergy(String name, String allergy) async {
    try {
      // 1. البحث عن المستندات التي تطابق الشروط
      QuerySnapshot querySnapshot = await _firestore
          .collection(_auth.currentUser!.uid)
          .where('name', isEqualTo: name)
          .where('allergie', isEqualTo: allergy)
          .get();

      // 2. حذف كل المستندات المطابقة
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print('Allergy deleted successfully!');
    } catch (e) {
      print('Error deleting allergy: $e');
      rethrow;
    }
  }
}
