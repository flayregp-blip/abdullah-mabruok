import 'package:get/get.dart';
import 'package:shortzz/common/controller/firebase_firestore_controller.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/model/livestream/app_user.dart';

class ChatThread {
  int? userId;
  String? id;
  int? msgCount;
  ChatType? chatType;
  String? requestType;
  String? lastMsg;
  String? conversationId;
  int? deletedId;
  bool? isDeleted;
  bool? iAmBlocked;
  bool? iBlocked;

  ChatThread({
    this.userId,
    this.id,
    this.msgCount,
    this.chatType,
    this.requestType,
    this.lastMsg,
    this.conversationId,
    this.deletedId,
    this.isDeleted,
    this.iAmBlocked,
    this.iBlocked,
  });

  ChatThread.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    msgCount = json['msg_count'];
    chatType = ChatType.fromString(json['chat_type']);
    requestType = json['request_type'];
    lastMsg = json['last_msg'];
    conversationId = json['conversation_id'];
    deletedId = json['deleted_id'];
    isDeleted = json['is_deleted'];
    iAmBlocked = json['i_am_blocked'];
    iBlocked = json['i_blocked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['id'] = id;
    data['msg_count'] = msgCount;
    data['chat_type'] = chatType?.value;
    data['request_type'] = requestType;
    data['last_msg'] = lastMsg;
    data['conversation_id'] = conversationId;
    data['deleted_id'] = deletedId;
    data['is_deleted'] = isDeleted;
    data['i_am_blocked'] = iAmBlocked;
    data['i_blocked'] = iBlocked;
    return data;
  }

  // Reactive variable for chat user
  final Rx<AppUser?> _chatUser = Rx<AppUser?>(null);

  /// ✅ Plain getter and setter (same type = AppUser?)
  AppUser? get chatUser => _chatUser.value;

  set chatUser(AppUser? user) {
    if (user == null) return;
    _chatUser.value = user; // update reactive value

    final controller = Get.find<FirebaseFirestoreController>();
    final index = controller.users.indexWhere((element) => element.userId == user.userId);

    if (index != -1) {
      controller.users[index] = user;
    } else {
      controller.users.add(user);
    }
  }

  /// ✅ Expose Rx version for reactive UI (`Obx`)
  Rx<AppUser?> get chatUserRx => _chatUser;

  /// ✅ Initialize and auto-sync with controller
  void bindChatUser() {
    final controller = Get.find<FirebaseFirestoreController>();

    void updateUser() {
      final appUser = controller.users.firstWhereOrNull((element) => element.userId == userId);

      if (appUser == null) {
        UserService.instance
            .fetchUserDetails(
          userId: userId,
          onError: () => controller.deleteUser(userId),
        )
            .then((value) {
          if (value == null) {
            controller.deleteUser(userId);
          } else {
            controller.addUser(value);
          }
        });
      }
      _chatUser.value = appUser;
    }

    // React when users list changes
    ever(controller.users, (_) => updateUser());

    // Initial call
    updateUser();
  }
}

enum ChatType {
  request('request'),
  approved('approved');

  final String value;

  const ChatType(this.value);

  static ChatType fromString(String value) {
    return ChatType.values.firstWhereOrNull((e) => e.value == value) ??
        ChatType.approved;
  }
}
