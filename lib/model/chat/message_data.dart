import 'package:get/get.dart';
import 'package:shortzz/common/controller/firebase_firestore_controller.dart';
import 'package:shortzz/model/livestream/app_user.dart';

class MessageData {
  int? id;
  int? userId;
  MessageType? messageType;
  String? textMessage;
  String? imageMessage;
  String? videoMessage;
  String? audioMessage;
  String? postMessage;
  String? storyReplyMessage;
  String? conversationId;
  bool? iBlocked;
  bool? iAmBlocked;
  List<int>? noDeleteIds;
  String? waveData;

  MessageData({this.userId,
      this.id,
      this.messageType,
      this.textMessage,
      this.imageMessage,
      this.videoMessage,
      this.audioMessage,
      this.postMessage,
      this.storyReplyMessage,
      this.conversationId,
      this.iBlocked,
      this.iAmBlocked,
      this.noDeleteIds,
      this.waveData});

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    messageType = MessageType.fromString(json['message_type']);
    textMessage = json['text_message'];
    imageMessage = json['image_message'];
    videoMessage = json['video_message'];
    audioMessage = json['audio_message'];
    postMessage = json['post_message'];
    storyReplyMessage = json['story_reply_message'];
    conversationId = json['conversation_id'];
    iBlocked = json['i_blocked'];
    iAmBlocked = json['i_am_blocked'];
    waveData = json['wave_data'];
    if (json['no_delete_ids'] != null) {
      noDeleteIds = [];
      json['no_delete_ids'].forEach((v) {
        noDeleteIds?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['message_type'] = messageType?.value;
    data['text_message'] = textMessage;
    data['image_message'] = imageMessage;
    data['video_message'] = videoMessage;
    data['audio_message'] = audioMessage;
    data['post_message'] = postMessage;
    data['story_reply_message'] = storyReplyMessage;
    data['conversation_id'] = conversationId;
    data['i_blocked'] = iBlocked;
    data['i_am_blocked'] = iAmBlocked;
    data['wave_data'] = waveData;
    data['no_delete_ids'] =
        noDeleteIds?.map((e) => e).toList(); // Include 'no_delete_ids'
    return data;
  }

  AppUser? get chatUser {
    final controller = Get.find<FirebaseFirestoreController>();
    return controller.users
        .firstWhereOrNull((element) => element.userId == userId);
  }
}

enum MessageType {
  text('text'),
  image('image'),
  video('video'),
  post('post'),
  gift('gift'),
  audio('audio'),
  gif('gif'),
  storyReply('story_reply');

  final String value;

  const MessageType(this.value);

  static MessageType fromString(String value) {
    return MessageType.values.firstWhereOrNull(
          (e) => e.value == value,
        ) ??
        MessageType.text;
  }
}

enum StoryReplyType {
  text('text'),
  gift('gift');

  final String value;

  const StoryReplyType(this.value);

  static StoryReplyType fromString(String value) {
    return StoryReplyType.values.firstWhereOrNull(
          (e) => e.value == value,
        ) ??
        StoryReplyType.text;
  }
}
