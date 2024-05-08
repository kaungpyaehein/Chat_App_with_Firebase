import 'dart:async';
import 'dart:convert';

import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseApiImpl implements FirebaseApi {
  var firestoreDb = FirebaseFirestore.instance;
  DatabaseReference databaseReference =
      FirebaseDatabase(databaseURL: kFirebaseDatabaseUrl).ref();

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
    } on FirebaseAuthException catch (error) {
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
    return await firestoreDb
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
  Future<UserVO> getUserDataFromFirestore(String userId) async {
    return await firestoreDb.collection(kUserCollection).doc(userId).get().then(
      (DocumentSnapshot snapshot) {
        if (snapshot.data() != null) {
          return UserVO.fromJson(snapshot.data() as Map<String, dynamic>);
        }
        throw Exception("Failed to get user data!");
      },
    );
  }

  //// Make this function more simpler
  @override
  Future<bool> exchangeContactsWithUids(
      String senderUid, String receiverUid) async {
    try {
      // Fetch sender and receiver snapshots concurrently
      List<DocumentSnapshot> snapshots = await Future.wait([
        firestoreDb.collection(kUserCollection).doc(senderUid).get(),
        firestoreDb.collection(kUserCollection).doc(receiverUid).get(),
      ]);

      if (snapshots[0].data() != null && snapshots[1].data() != null) {
        // Extract sender and receiver data from snapshots
        Map<String, dynamic> senderData =
            snapshots[0].data() as Map<String, dynamic>;
        Map<String, dynamic> receiverData =
            snapshots[1].data() as Map<String, dynamic>;

        // Execute set operations concurrently
        await Future.wait([
          firestoreDb
              .collection(kUserCollection)
              .doc(receiverUid)
              .collection(kContactsCollection)
              .doc(senderUid)
              .set(senderData, SetOptions(merge: true)),
          firestoreDb
              .collection(kUserCollection)
              .doc(senderUid)
              .collection(kContactsCollection)
              .doc(receiverUid)
              .set(receiverData, SetOptions(merge: true)),
        ]);

        // Return true if both operations succeed
        return true;
      }
      return false;
    } catch (error) {
      // Handle any errors
      print("Error adding contact: $error");
      return false;
    }
  }

  @override
  Stream<List<UserVO>> getContactsStream(String uid) {
    return FirebaseFirestore.instance
        .collection(kUserCollection)
        .doc(uid)
        .collection(kContactsCollection)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => UserVO.fromJson(doc.data()))
            .toList());
  }

  @override
  void sendMessage(
      MessageVO message, String senderId, String receiverId) async {
    /// Save message to sender side
    await databaseReference.child("chats").update({
      "$senderId/$receiverId/${message.id}": message.toJson(),
    });

    /// Save message to receiver side
    await databaseReference.child("chats").update({
      "$receiverId/$senderId/${message.id}": message.toJson(),
    });
  }

  @override
  Stream<List<MessageVO>> getMessageStream(
      String senderUid, String receiverUid) {
    return databaseReference
        .child("chats/$senderUid/$receiverUid")
        .onValue
        .map((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      print("Data received: ${dataSnapshot.value}");
      var values = dataSnapshot.value as Map<dynamic, dynamic>?;

      List<MessageVO> messages = [];
      print("messages${messages.toString()}");

      if (values != null) {
        values.forEach((key, value) {
          // Assuming value is the JSON object representing a message
          // Use the key as the id
          messages.add(MessageVO.fromJson({
            ...value,
            'id': key,
          }));
        });
      }

      print("messages${messages.toString()}");
      return messages;
    });
  }
}
