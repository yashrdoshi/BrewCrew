import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference

  final CollectionReference brewCollection =
      Firestore.instance.collection("brew");

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection
        .document(uid)
        .setData({'sugars': sugars, 'name': name, 'strength': strength});
  }

  //brew list from Snapshots
  List<Brew> _brewListFromSanpshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? "",
        sugars: doc.data['sugars'] ?? '0',
        strength: doc.data['strength'] ?? 0,
      );
    }).toList();
  }
  //user data from snapshots

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  //get brews Stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSanpshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
