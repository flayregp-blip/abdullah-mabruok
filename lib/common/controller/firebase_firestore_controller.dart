import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/extensions/user_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/firebase_const.dart';

class FirebaseFirestoreController extends BaseController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  RxList<AppUser> users = <AppUser>[].obs;

  static final instance = FirebaseFirestoreController();

  void fetchUserIfNeeded(int userId) {
    Loggers.info('[LOAD_USER] Checking if user $userId already exists in list');

    final exists = users.any((element) => element.userId == userId);
    if (exists) {
      Loggers.info('[LOAD_USER] User $userId already loaded, skipping fetch');
      return;
    }

    Loggers.info('[LOAD_USER] Fetching user $userId from Firestore');

    db
        .collection(FirebaseConst.appUsers)
        .where('user_id', whereIn: [userId])
        .withConverter<AppUser>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data();
            if (data != null) {
              Loggers.info('[LOAD_USER] User $userId data received');
              return AppUser.fromJson(data);
            } else {
              Loggers.warning('[LOAD_USER] User $userId snapshot data is null');
              return AppUser();
            }
          },
          toFirestore: (user, _) => user.toJson(),
        )
        .get()
        .then((value) {
          Loggers.info('[LOAD_USER] Firestore fetch completed for user $userId');
          for (var element in value.docChanges) {
            final fetchedUser = element.doc.data();
            if (fetchedUser != null) {
              users.add(fetchedUser);
              Loggers.info('[LOAD_USER] User ${fetchedUser.userId} added to list');
            } else {
              Loggers.warning('[LOAD_USER] Null user data in docChanges');
            }
          }
        })
        .catchError((error) {
          Loggers.error('[LOAD_USER] Failed to fetch user $userId — $error');
        });
  }

  void updateUser(User? user) async {
    if (user == null) return;
    DocumentSnapshot<AppUser> value = await db
        .collection(FirebaseConst.appUsers)
        .doc('${user.id}')
        .withConverter(
          fromFirestore: (snapshot, options) => AppUser.fromJson(snapshot.data()!),
          toFirestore: (AppUser value, options) {
            return value.toJson();
          },
        )
        .get();
    AppUser? chatUser = user.appUser;

    if (value.exists) {
      db.collection(FirebaseConst.appUsers).doc('${user.id}').update(chatUser.toJson());
    }
  }

  void addUser(User? user) async {
    if (user == null) return;
    DocumentSnapshot<AppUser> value = await db
        .collection(FirebaseConst.appUsers)
        .doc('${user.id}')
        .withConverter(
          fromFirestore: (snapshot, options) => AppUser.fromJson(snapshot.data()!),
          toFirestore: (AppUser value, options) {
            return value.toJson();
          },
        )
        .get();
    AppUser? chatUser = user.appUser;

    if (!value.exists) {
      db.collection(FirebaseConst.appUsers).doc('${user.id}').set(chatUser.toJson());
    }
  }

  Future<void> deleteUser(int? userId) async {
    if (userId == null) return;
    final userListSnapshot =
        await db.collection(FirebaseConst.users).doc('$userId').collection(FirebaseConst.usersList).get();

    final batch = db.batch();

    for (var doc in userListSnapshot.docs) {
      final otherUserId = doc.id;
      print(otherUserId);
      final otherUserRef =
          db.collection(FirebaseConst.users).doc(otherUserId).collection(FirebaseConst.usersList).doc('$userId');

      final currentUserRef =
          db.collection(FirebaseConst.users).doc('$userId').collection(FirebaseConst.usersList).doc(otherUserId);

      batch.delete(otherUserRef);
      batch.delete(currentUserRef);
      await db.collection(FirebaseConst.appUsers).doc('$userId').delete();
    }

    await batch.commit();
  }
}
