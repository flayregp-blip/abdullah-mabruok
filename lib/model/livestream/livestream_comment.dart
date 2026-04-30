import 'package:get/get.dart';
import 'package:shortzz/common/controller/firebase_firestore_controller.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/livestream/app_user.dart';

class LivestreamComment {
  int? senderId;
  int? receiverId;
  String? comment;
  LivestreamCommentType? commentType;
  int? giftId;
  int? id;
  Gift? gift;

  LivestreamComment(
      {this.senderId,
      this.receiverId,
      this.comment,
      this.commentType,
      this.giftId,
      this.id,
      this.gift});

  LivestreamComment.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    comment = json['comment'];
    commentType = LivestreamCommentType.fromString(json['comment_type']);
    giftId = json['gift_id'];
    id = json['id'];
    gift = json['gift'] != null ? Gift.fromJson(json['gift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sender_id'] = senderId;
    data['receiver_id'] = receiverId;
    data['comment'] = comment;
    data['comment_type'] = commentType?.value;
    data['gift_id'] = giftId;
    data['id'] = id;
    if (gift != null) {
      data['gift'] = gift?.toJson();
    }
    return data;
  }


  set senderUser(AppUser? user) {
    if (user == null) return;
    final controller = Get.find<FirebaseFirestoreController>();
    final index =
        controller.users.indexWhere((element) => element.userId == user.userId);
    if (index != -1) {
      controller.users[index] = user;
    } else {
      controller.users.add(user);
    }
  }

  AppUser? get receiverUser {
    final controller = Get.find<FirebaseFirestoreController>();
    return controller.users
        .firstWhereOrNull((element) => element.userId == receiverId);
  }

  set receiverUser(AppUser? user) {
    if (user == null) return;
    final controller = Get.find<FirebaseFirestoreController>();
    final index =
        controller.users.indexWhere((element) => element.userId == user.userId);
    if (index != -1) {
      controller.users[index] = user;
    } else {
      controller.users.add(user);
    }
  }

  // Reactive variable for chat user
  final Rx<AppUser?> _senderUser = Rx<AppUser?>(null);

  /// ✅ Expose Rx version for reactive UI (`Obx`)
  Rx<AppUser?> get senderUserRx => _senderUser;

  /// ✅ Initialize and auto-sync with controller
  void bindCommentUser() {
    final controller = Get.find<FirebaseFirestoreController>();

    void updateUser() {
      final appUser = controller.users.firstWhereOrNull((element) => element.userId == senderId);

      _senderUser.value = appUser;
    }

    // React when users list changes
    ever(controller.users, (_) => updateUser());

    // Initial call
    updateUser();
  }
}

enum LivestreamCommentType {
  request('REQUEST'),
  text('TEXT'),
  gift('GIFT'),
  joined('JOINED'),
  joinedCoHost('JOINED_CO_HOST');

  final String value;

  const LivestreamCommentType(this.value);

  static LivestreamCommentType fromString(String value) {
    return LivestreamCommentType.values
            .firstWhereOrNull((e) => e.value == value) ??
        LivestreamCommentType.text;
  }
}
