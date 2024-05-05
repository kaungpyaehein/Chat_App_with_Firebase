import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApiImpl implements FirebaseApi {
  var db = FirebaseFirestore.instance;
  @override
  Future<String?> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is signed in
      if (user != null) {
        String uid = user.uid;
        return uid;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> registerAccount(
    String email,
    String password,
    String name,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is signed in
      if (user != null) {
        String uid = user.uid;
        return uid;
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addUserDataToFirestore(UserVO userVO) async {
    return await db
        .collection("users")
        .doc(userVO.id)
        .set(userVO.toJson(), SetOptions(merge: true))
        .then((value) {
      return true;
    }).catchError((error) {
      return false;
    });
  }

  @override
  Future<UserVO?> getUserDatFromFirestore(String userId) async {
    return await db.collection("users").doc(userId).get().then(
      (DocumentSnapshot snapshot) {
        return UserVO.fromJson(snapshot.data() as Map<String, dynamic>);
      },
    );
  }

  //// Make this function more simpler
  @override
  Future<bool> addContactWithUid(String senderUid, String receiverUid) async {
    try {
      // Fetch sender and receiver snapshots concurrently
      List<DocumentSnapshot> snapshots = await Future.wait([
        db.collection("users").doc(senderUid).get(),
        db.collection("users").doc(receiverUid).get(),
      ]);

      // Extract sender and receiver data from snapshots
      Map<String, dynamic> senderData =
          snapshots[0].data() as Map<String, dynamic>;
      Map<String, dynamic> receiverData =
          snapshots[1].data() as Map<String, dynamic>;

      // Execute set operations concurrently
      await Future.wait([
        db
            .collection("users")
            .doc(receiverUid)
            .collection("contacts")
            .doc(senderUid)
            .set(senderData, SetOptions(merge: true)),
        db
            .collection("users")
            .doc(senderUid)
            .collection("contacts")
            .doc(receiverUid)
            .set(receiverData, SetOptions(merge: true)),
      ]);

      // Return true if both operations succeed
      return true;
    } catch (error) {
      // Handle any errors
      print("Error adding contact: $error");
      return false;
    }
  }
}
