import 'dart:async';
import 'dart:convert';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shortzz/common/enum/chat_enum.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/extensions/user_extension.dart';
import 'package:shortzz/common/functions/media_picker_helper.dart';
import 'package:shortzz/common/manager/firebase_notification_manager.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/common_service.dart';
import 'package:shortzz/common/service/api/notification_service.dart';
import 'package:shortzz/common/service/api/post_service.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/chat/chat_thread.dart';
import 'package:shortzz/model/chat/message_data.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/post_story/story/story_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/blocked_user_screen/block_user_controller.dart';
import 'package:shortzz/screen/chat_screen/message_type_widget/chat_audio_message.dart';
import 'package:shortzz/screen/chat_screen/widget/select_media_sheet.dart';
import 'package:shortzz/screen/chat_screen/widget/send_media_sheet.dart';
import 'package:shortzz/screen/gif_sheet/gif_sheet.dart';
import 'package:shortzz/screen/gift_sheet/send_gift_sheet_controller.dart';
import 'package:shortzz/screen/post_screen/post_screen_controller.dart';
import 'package:shortzz/screen/post_screen/single_post_screen.dart';
import 'package:shortzz/screen/reels_screen/reel/reel_page_controller.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/screen/report_sheet/report_sheet.dart';
import 'package:shortzz/screen/story_view_screen/story_view_screen.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/firebase_const.dart';
import 'package:shortzz/utilities/style_res.dart';

class ChatScreenController extends BlockUserController with GetTickerProviderStateMixin {
  List<UserRequestAction> requestType = UserRequestAction.values;
  User? myUser = SessionManager.instance.getUser();
  final Setting? setting = SessionManager.instance.getSettings();
  User? otherUser;

  RxBool isTextEmpty = true.obs;
  RxBool hasMore = true.obs;
  RxBool isExpanded = false.obs;
  bool isPostAPiCalling = false;

  TextEditingController textController = TextEditingController();
  TextEditingController mediaTextController = TextEditingController();
  Rx<ChatThread> conversationUser;
  ChatThread? myConversationUser;

  late DocumentReference documentSender;
  late CollectionReference collectionUsersRef;
  late DocumentReference documentReceiver;
  late CollectionReference chatCollection;
  late AnimationController audioAnimationController;
  Animation<double>? audioWidthAnimation;

  FirebaseFirestore db = FirebaseFirestore.instance;
  MessageType chatType = MessageType.text;

  RxList<MessageData> chatList = <MessageData>[].obs;
  List<StreamSubscription<QuerySnapshot<MessageData>>> chatListeners = [];
  List<StreamSubscription<DocumentSnapshot<ChatThread>>> usersStreams = [];

  StreamSubscription<PlayerState>? playerControllerListen;

  DocumentSnapshot<MessageData>? lastDocument;

  RecorderController recorderController = RecorderController();
  PlayerController playerController = PlayerController();
  Rx<PlayerValue> playerValue = PlayerValue(state: PlayerState.stopped, id: 0).obs;

  ChatScreenController(this.conversationUser);

  static String chatId = '';

  @override
  void onInit() {
    super.onInit();
    chatId = conversationUser.value.conversationId ?? 'No CONVERSATION';
    String otherUserid = '${conversationUser.value.chatUser?.userId ?? -1}';
    String conversationId = conversationUser.value.conversationId ?? 'No CONVERSATION';
    collectionUsersRef = db.collection(FirebaseConst.appUsers);

    documentSender = db
        .collection(FirebaseConst.users)
        .doc(myUser?.id.toString())
        .collection(FirebaseConst.usersList)
        .doc(otherUserid);
    documentReceiver = db
        .collection(FirebaseConst.users)
        .doc(otherUserid)
        .collection(FirebaseConst.usersList)
        .doc(myUser?.id.toString());
    chatCollection =
        db.collection(FirebaseConst.chats).doc(conversationId).collection(FirebaseConst.messages);
  }

  @override
  void onReady() {
    super.onReady();
    _init();
    _getChat();
    _addUsersFirebaseFireStore();
  }

  @override
  void onClose() {
    super.onClose();
    chatId = '';
    for (var listener in chatListeners) {
      listener.cancel();
    }
    for (var listener in usersStreams) {
      listener.cancel();
    }

    playerControllerListen?.cancel();
    audioAnimationController.dispose();
    recorderController.dispose();
    playerController.dispose();
    textController.dispose();
    mediaTextController.dispose();

    _markAsRead();
  }

  _init() {
    _initAudioAnimationController();
    _initializePlayerStateListener();
    _fetchOtherUser();
  }

  _initAudioAnimationController() {
    audioAnimationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    final double maxWidth = Get.width - 30;

    audioWidthAnimation = Tween<double>(
      begin: 0, // Start with 0 width
      end: maxWidth, // Expand to full width
    ).animate(CurvedAnimation(parent: audioAnimationController, curve: Curves.easeInOut));
  }

  _initializePlayerStateListener() {
    playerControllerListen = playerController.onPlayerStateChanged.listen((event) {
      playerValue.update((val) => val?.state = event);
      Loggers.success('Player State: $event');
    });
  }

  _fetchOtherUser() async {
    int userId = conversationUser.value.userId ?? -1;
    if (userId != -1) {
      otherUser = await UserService.instance.fetchUserDetails(userId: userId);
      Loggers.info('Other User Device Token: ${otherUser?.deviceToken}');
    }
  }

  void _listenToChatThreadUser() {
    var otherConversationStream = documentSender
        .withConverter(
          fromFirestore: (snapshot, options) => ChatThread.fromJson(snapshot.data()!),
          toFirestore: (ChatThread value, options) => value.toJson(),
        )
        .snapshots()
        .listen((event) {
      if (event.exists) {
        conversationUser.value = event.data()!;
        Loggers.info('Chat Updated: ${conversationUser.value.toJson()}');
      } else {
        Loggers.info('Chat User Not Found ${event.data()}');
        conversationUser.update((val) => val?.chatType = ChatType.approved);
      }
    });

    var myConversationStream = documentReceiver
        .withConverter(
          fromFirestore: (snapshot, options) => ChatThread.fromJson(snapshot.data()!),
          toFirestore: (ChatThread value, options) => value.toJson(),
        )
        .snapshots()
        .listen((event) {
      if (event.exists) {
        myConversationUser = event.data()!;
        Loggers.success('Other Chat Updated: ${myConversationUser?.toJson()}');
      }
    });
    usersStreams.addAll([otherConversationStream, myConversationStream]);
  }

  void onSendTextMessage() async {
    String text = textController.text.trim();
    textController.clear();
    isTextEmpty.value = true;
    if (conversationUser.value.iAmBlocked ?? false) {
      return showSnackBar(
          'You cannot message ${conversationUser.value.chatUser?.username} because you are blocked by them.');
    }
    sendMessageToFireStore(type: MessageType.text, textMessage: text);
  }

  Future<void> sendMessageToFireStore(
      {required MessageType type,
      String? textMessage,
      String? imageMessage,
      String? videoMessage,
      String? audioMessage,
      String? postMessage,
      String? storyReplyMessage,
      List<double>? waveData}) async {
    int time = DateTime.now().millisecondsSinceEpoch;

    List<int> noDeleteIds = [
      myUser?.id ?? -1,
      conversationUser.value.chatUser?.userId ?? -1,
    ];

    MessageData message = MessageData(
      userId: myUser?.id,
      conversationId: conversationUser.value.conversationId,
      textMessage: textMessage,
      iAmBlocked: false,
      iBlocked: false,
      imageMessage: imageMessage,
      videoMessage: videoMessage,
      postMessage: postMessage,
      storyReplyMessage: storyReplyMessage,
      messageType: type,
      id: time,
      noDeleteIds: noDeleteIds,
      audioMessage: audioMessage,
      waveData: waveData?.join(','),
    );

    Loggers.success('FIREBASE MESSAGE : ${message.toJson()}');

    // Entry chat list
    chatCollection.doc(time.toString()).set(message.toJson()).catchError((error) {
      Loggers.error('Chat Collection ERROR : $error');
    });

    // For Sender side
    bool isReceiverUserExist = (await documentSender.get()).exists;

    // Loggers.success('RECEIVER USER isExist: $isReceiverUserExist');
    String senderLastMessage = getLastMessage(type, message, isSender: true);
    String receiverLastMessage = getLastMessage(type, message, isSender: false);
    ChatThread conversation = conversationUser.value;
    conversation.id = time.toString();
    conversation.lastMsg = senderLastMessage;
    conversation.msgCount = 0;
    conversation.isDeleted = false;

    if (isReceiverUserExist) {
      documentSender.update(conversation.toJson());
    } else {
      documentSender.set(conversation.toJson());
    }

    // For Receiver side
    bool isSenderUserExist = (await documentReceiver.get()).exists;
    // Loggers.success('SENDER USER isExist: $isSenderUserExist');

    if (isSenderUserExist) {
      documentReceiver.update({
        FirebaseConst.msgCount: FieldValue.increment(1),
        FirebaseConst.lastMsg: receiverLastMessage,
        FirebaseConst.isDeleted: false,
        FirebaseConst.id: time.toString()
      });
    } else {
      ChatType status = ChatType.approved;
      String? requestType = UserRequestAction.accept.title;

      if (otherUser != null) {
        status = otherUser?.followStatus == 2 || otherUser?.followStatus == 3
            ? ChatType.approved
            : ChatType.request;
        requestType = otherUser?.followStatus == 2 || otherUser?.followStatus == 3
            ? UserRequestAction.accept.title
            : null;
      }
      ChatThread myConversation = ChatThread(
          id: time.toString(),
          conversationId: conversationUser.value.conversationId,
          chatType: status,
          msgCount: 1,
          lastMsg: receiverLastMessage,
          userId: myUser?.id,
          isDeleted: false,
          deletedId: 0,
          iBlocked: false,
          iAmBlocked: false,
          requestType: requestType);
      myConversationUser = myConversation;
      documentReceiver.set(myConversation.toJson());
    }

    pushNotificationToUser(message);
  }

  void pushNotificationToUser(MessageData message) {
    if (otherUser?.notifyChat == 0) return;

    String bodyMessage = '';
    switch (message.messageType) {
      case MessageType.image:
        bodyMessage =
            'Shared a Photo${(message.textMessage ?? '').isNotEmpty ? ': ${message.textMessage}' : ""}';
      case MessageType.video:
        bodyMessage =
            'Shared a Video${(message.textMessage ?? '').isNotEmpty ? ': ${message.textMessage}' : ""}';
      case MessageType.post:
        bodyMessage = 'Shared a Post';
      case MessageType.audio:
        bodyMessage = '🎙️ Sent a voice message';
      case MessageType.text:
        bodyMessage = message.textMessage ?? '';
      case MessageType.gift:
        bodyMessage = 'Sent a Gift';
      case MessageType.gif:
        bodyMessage = 'Sent a GIF';
      case MessageType.storyReply:
        bodyMessage = 'Sent a Story Reply';
      case null:
        bodyMessage = '';
    }

    NotificationService.instance.pushNotification(
        title: myUser?.fullname ?? '',
        body: bodyMessage,
        token: otherUser?.deviceToken,
        deviceType: otherUser?.device,
        type: NotificationType.chat,
        data: myConversationUser?.toJson());
  }

  String getLastMessage(MessageType type, MessageData message, {bool isSender = true}) {
    String prefix = isSender ? "You: " : "";
    String sentPrefix = isSender ? "You sent " : "Sent you ";

    switch (type) {
      case MessageType.text:
        return "$prefix${message.textMessage ?? ''}";
      case MessageType.image:
        return '${sentPrefix}an Image';
      case MessageType.video:
        return '${sentPrefix}a Video';
      case MessageType.gift:
        return '${sentPrefix}a Gift';
      case MessageType.audio:
        return '${sentPrefix}a voice message';
      case MessageType.gif:
        return '${sentPrefix}a GIF';
      case MessageType.post:
        Post post = Post.fromJson(jsonDecode(message.postMessage ?? ''));
        return '$sentPrefix@${post.user?.username ?? ''}\'s post';
      case MessageType.storyReply:
        return '${sentPrefix}a Story Reply';
    }
  }

  void onTextFieldChanged(String value) {
    if (value.trim().isNotEmpty) {
      isTextEmpty.value = false;
    } else {
      isTextEmpty.value = true;
    }
  }

  void _getChat() async {
    _listenToChatThreadUser();
    await Future.delayed(const Duration(milliseconds: 100));
    var subscription = chatCollection
        .where(FirebaseConst.noDeleteIds, arrayContains: myUser?.id)
        .where(FirebaseConst.id, isGreaterThan: conversationUser.value.deletedId)
        .orderBy(FirebaseConst.id, descending: true)
        .limit(AppRes.chatPaginationLimit)
        .withConverter(
            fromFirestore: (snapshot, options) => MessageData.fromJson(snapshot.data()!),
            toFirestore: (MessageData value, options) => value.toJson())
        .snapshots()
        .listen((event) {
      Loggers.info(' FETCHING CHAT MESSAGES : ${event.docChanges.length}');
      for (var change in event.docChanges) {
        final message = change.doc.data();
        if (message == null) continue;
        switch (change.type) {
          case DocumentChangeType.added:
            chatList.add(message);
            break;
          case DocumentChangeType.modified:
            chatList.removeWhere((element) => element.id == message.id);
            chatList.add(message);
            break;
          case DocumentChangeType.removed:
            chatList.removeWhere((element) => element.id == message.id);
            break;
        }
      }

      chatList.sort((a, b) => b.id?.compareTo(a.id ?? 0) ?? 0);

      if (event.docs.isNotEmpty) {
        lastDocument = event.docs.last;
      }
    });
    chatListeners.add(subscription);
  }

  Future<void> fetchMoreChatList() async {
    if (!hasMore.value || isLoading.value) return;
    isLoading.value = true;

    try {
      var query = chatCollection
          .where(FirebaseConst.noDeleteIds, arrayContains: myUser?.id)
          .where(FirebaseConst.id, isGreaterThan: conversationUser.value.deletedId)
          .orderBy(FirebaseConst.id, descending: true)
          .limit(AppRes.chatPaginationLimit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      // Use snapshots() instead of get()
      var subscription = query
          .withConverter(
            fromFirestore: (snapshot, _) => MessageData.fromJson(snapshot.data()!),
            toFirestore: (msg, _) => msg.toJson(),
          )
          .snapshots()
          .listen((event) {
        if (event.docs.isEmpty) {
          hasMore.value = false;
          return;
        }

        lastDocument = event.docs.last;

        for (var change in event.docChanges) {
          final message = change.doc.data();
          if (message == null) continue;

          switch (change.type) {
            case DocumentChangeType.added:
              if (!chatList.any((m) => m.id == message.id)) {
                chatList.add(message);
              }
              break;
            case DocumentChangeType.modified:
              chatList.removeWhere((m) => m.id == message.id);
              chatList.add(message);
              break;
            case DocumentChangeType.removed:
              chatList.removeWhere((m) => m.id == message.id);
              break;
          }
        }

        chatList.sort((a, b) => b.id?.compareTo(a.id ?? 0) ?? 0);
      });

      // Store this listener
      chatListeners.add(subscription);
    } catch (e) {
      Loggers.error("Error in live paginated fetch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  onChatActionTap(ChatAction action) {
    if (conversationUser.value.iAmBlocked ?? false) {
      return showSnackBar(
          'You cannot message ${conversationUser.value.chatUser?.username} because you are blocked by them.');
    }
    FocusManager.instance.primaryFocus?.unfocus();
    switch (action) {
      case ChatAction.gift:
        pickGift();
        break;
      case ChatAction.audio:
        _pickAudio();
        break;
      case ChatAction.sticker:
        pickSticker();
        break;
      case ChatAction.media:
        pickAndSendMedia();
        break;
    }
  }

  void onCameraTap() {
    if (conversationUser.value.iAmBlocked ?? false) {
      return showSnackBar(
          'You cannot message ${conversationUser.value.chatUser?.username} because you are blocked by them.');
    }
    FocusManager.instance.primaryFocus?.unfocus();
    Get.bottomSheet(SelectMediaSheet(
      onSelectMedia: (mediaFile) {
        Get.back();
        _showSendMediaSheet(mediaFile);
      },
    ), isScrollControlled: true);
  }

  void pickGift() {
    int? userId = conversationUser.value.chatUser?.userId;

    GiftManager.openGiftSheet(
        userId: userId ?? -1,
        onCompletion: (giftManager) {
          sendMessageToFireStore(
              type: MessageType.gift,
              textMessage: giftManager.gift.coinPrice.toString(),
              imageMessage: giftManager.gift.image);
        });
  }

  void pickSticker() {
    Get.bottomSheet<String?>(const GifSheet(), isScrollControlled: true).then((value) {
      if (value != null) {
        sendMessageToFireStore(type: MessageType.gif, imageMessage: value);
      }
    });
  }

  void pickAndSendMedia() async {
    MediaFile? mediaFile = await MediaPickerHelper.shared.pickMedia();
    if (mediaFile == null) return;
    mediaTextController.clear();
    _showSendMediaSheet(mediaFile);
  }

  void _showSendMediaSheet(MediaFile mediaFile) {
    Get.bottomSheet(
      SendMediaSheet(
          controller: this,
          image: mediaFile.thumbNail.path,
          onSendBtnClick: () {
            Get.back();
            _uploadAndSendMessage(mediaFile);
          }),
      isScrollControlled: true,
    );
  }

  Future<void> _uploadAndSendMessage(MediaFile mediaFile) async {
    showLoader();

    String filePath = await _uploadFile(mediaFile.file);

    Loggers.success(filePath);

    String thumbnailPath =
        mediaFile.type == MediaType.video ? await _uploadFile(mediaFile.thumbNail) : '';
    stopLoader();
    bool isImageMessage = mediaFile.type == MediaType.image;
    Loggers.success('THIS IS IMAGE MESSAGE : $isImageMessage');
    if (filePath == '') {
      return Loggers.error('Filepath Not Found Please try Again');
    }
    if (!isImageMessage && thumbnailPath == '') {
      return Loggers.error('ThumbnailPath Not Found Please try Again');
    }

    sendMessageToFireStore(
      type: isImageMessage ? MessageType.image : MessageType.video,
      imageMessage: isImageMessage ? filePath : thumbnailPath,
      videoMessage: !isImageMessage ? filePath : thumbnailPath,
      textMessage: mediaTextController.text.trim(),
    );
  }

  Future<String> _uploadFile(XFile file) async {
    return (await CommonService.instance.uploadFileGivePath(file)).data ?? '';
  }

  void toggleAnimation() {
    if (isExpanded.value) {
      audioAnimationController.reverse();
    } else {
      audioAnimationController.forward();
    }
    isExpanded.value = !isExpanded.value;
  }

  void _pickAudio() async {
    recorderController = RecorderController();
    bool isGranted = await recorderController.checkPermission();
    if (isGranted) {
      audioAnimationController.forward();
      recorderController.record(recorderSettings: const RecorderSettings());
    } else {
      Get.bottomSheet(
          ConfirmationSheet(
              title: LKey.enableMicrophoneAccessTitle.tr,
              description: LKey.enableMicrophoneAccessDescription.tr,
              onTap: openAppSettings,
              positiveText: LKey.settings.tr),
          isScrollControlled: true);
    }
  }

  void deleteRecordedAudio() async {
    audioAnimationController.reverse();
    recorderController.reset();
    recorderController.dispose();
  }

  void sendRecordedAudio() async {
    audioAnimationController.reverse();
    showLoader();

    try {
      String? recordedFilePath = await recorderController.stop();
      if (recordedFilePath != null) {
        List<double> waveData = await playerController.waveformExtraction.extractWaveformData(
            path: recordedFilePath, noOfSamples: playerWaveStyle.getSamplesForWidth(wavesWidth));

        Loggers.info('Recorded file path: $recordedFilePath');

        String audioUrl = await _uploadFile(XFile(recordedFilePath));
        sendMessageToFireStore(
          type: MessageType.audio,
          audioMessage: audioUrl,
          waveData: waveData,
        );
      } else {
        Loggers.error('Audio path not found');
      }
    } catch (e) {
      Loggers.error('Audio recording error: $e');
    } finally {
      stopLoader();
      recorderController.dispose();
    }
  }

  void startAudioPlayback() async {
    await playerController.startPlayer();
    playerController.setFinishMode(finishMode: FinishMode.pause);
  }

  void pauseAudioPlayback() async {
    await playerController.pausePlayer();
  }

  void toggleAudioPlayback(MessageData message) {
    if (playerValue.value.id == message.id) {
      switch (playerValue.value.state) {
        case PlayerState.initialized:
        case PlayerState.playing:
          pauseAudioPlayback();
          break;
        case PlayerState.paused:
          startAudioPlayback();
          break;
        case PlayerState.stopped:
          break;
      }
    } else {
      playAudioMessage(message);
    }
  }

  void playAudioMessage(MessageData message) async {
    String audioUrl = message.audioMessage?.addBaseURL() ?? '';
    if (audioUrl.isEmpty) return;

    DefaultCacheManager().getSingleFile(audioUrl).then((file) async {
      playerController.release();
      await playerController.preparePlayer(
        path: file.path,
        noOfSamples: playerWaveStyle.getSamplesForWidth(wavesWidth),
      );

      playerValue.value = PlayerValue(state: PlayerState.initialized, id: message.id ?? 0);
      startAudioPlayback();
    });
  }

  void onDeleteForYou(MessageData message) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      MessageData? data = (await chatCollection
              .doc(message.id.toString())
              .withConverter(
                  fromFirestore: (snapshot, options) => MessageData.fromJson(snapshot.data()!),
                  toFirestore: (MessageData value, options) => value.toJson())
              .get())
          .data();

      if (data != null) {
        List<int> ids = data.noDeleteIds ?? [];
        if (ids.length < 2) {
          await chatCollection.doc(message.id.toString()).delete();
          await _deleteAssociatedFiles(message);
        } else {
          await chatCollection.doc(message.id.toString()).update({
            FirebaseConst.noDeleteIds: FieldValue.arrayRemove([myUser?.id])
          });
          chatList.removeWhere((element) => element.id == data.id);
        }
      }
    } catch (e) {
      Loggers.error('On Delete For You error : $e');
    }
  }

  void onUnSend(MessageData message) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      await chatCollection.doc(message.id.toString()).delete();
      await _deleteAssociatedFiles(message);
    } catch (e) {
      Loggers.error('Un-send message error: $e');
    }
  }

  Future<void> _deleteAssociatedFiles(MessageData message) async {
    switch (message.messageType) {
      case MessageType.text:
        break;
      case MessageType.image:
        await deleteFile(message.imageMessage ?? '');
        break;
      case MessageType.video:
        await deleteFile(message.videoMessage ?? '');
        await deleteFile(message.imageMessage ?? '');
        break;
      case MessageType.audio:
        await deleteFile(message.audioMessage ?? '');
        break;
      case MessageType.gift:
        break;
      case MessageType.gif:
        break;
      case MessageType.post:
        break;
      case MessageType.storyReply:
        break;
      case null:
        break;
    }
  }

  Future<bool> deleteFile(String file) async {
    StatusModel response = await CommonService.instance.deleteFile(file);
    if (response.status == true) return true;
    return false;
  }

  void onChatRequestTap(UserRequestAction requestType, ChatThread conversation) async {
    switch (requestType) {
      case UserRequestAction.block:
        AppUser? user = conversation.chatUser;
        blockUser(
            User(
                id: user?.userId,
                profilePhoto: user?.profile,
                username: user?.username,
                fullname: user?.fullname,
                isVerify: user?.isVerify),
            () {});
        break;
      case UserRequestAction.reject:
        await documentSender.update({
          FirebaseConst.requestType: UserRequestAction.reject.title,
          FirebaseConst.deletedId: DateTime.now().millisecondsSinceEpoch,
          FirebaseConst.isDeleted: true,
        });
        Get.back();
        break;
      case UserRequestAction.accept:
        documentSender.update({
          FirebaseConst.chatType: ChatType.approved.value,
          FirebaseConst.requestType: UserRequestAction.accept.title,
        });
        break;
    }
  }

  void onPostTap(Post post) async {
    PostType type = post.postType;
    playerController.pausePlayer();
    fetchPost(postType: post.postType, post: post);
    switch (type) {
      case PostType.reel:
      case PostType.video:
        Get.to(() => ReelsScreen(reels: [post].obs, position: 0, pageType: ReelPageType.single));
        break;
      case PostType.image:
      case PostType.text:
        Get.to(() => SinglePostScreen(post: post, isFromNotification: false));
        break;
      case PostType.none:
        break;
    }
  }

  void fetchPost({required PostType postType, Post? post}) async {
    Post? _post = (await PostService.instance.fetchPostById(postId: post?.id ?? -1)).data?.post;
    if (_post == null) return;
    switch (postType) {
      case PostType.image:
      case PostType.text:
        Get.find<PostScreenController>(tag: _post.id.toString()).updatePost(_post);
        break;
      case PostType.reel:
      case PostType.video:
        Get.find<ReelController>(tag: _post.id.toString()).updateReelData(reel: _post);
        break;
      case PostType.none:
        break;
    }
  }

  void onReportUser(ChatThread chatThread) {
    Get.bottomSheet(ReportSheet(reportType: ReportType.user, id: chatThread.chatUser?.userId),
        isScrollControlled: true);
  }

  void toggleBlockUnblock(ChatThread chatThread) {
    if (chatThread.iBlocked ?? false) {
      unblockUser(otherUser, () {});
    } else {
      blockUser(otherUser, () {});
    }
  }

  void sendStoryReply({required Story story, required String textReply, String? imageReply}) {
    sendMessageToFireStore(
        type: MessageType.storyReply,
        imageMessage: imageReply,
        textMessage: textReply,
        storyReplyMessage: jsonEncode(story.toJsonWithUser()));
  }

  _markAsRead() async {
    if ((await documentSender.get()).exists) {
      await documentSender.update({FirebaseConst.msgCount: 0});
    }
  }

  void removeStoryFromChat(MessageData message) async {
    DocumentReference firebaseDocuments = chatCollection.doc(message.id.toString());
    await firebaseDocuments.get().then((value) {
      if (value.exists) {
        firebaseDocuments.update({
          FirebaseConst.storyReplyMessage: jsonEncode(Story()),
        });
      }
    });
  }

  void onStoryTap(MessageData message, Story story) {
    final createdAtStr = story.createdAt;
    if (createdAtStr == null || createdAtStr.isEmpty) {
      removeStoryFromChat(message);
      return;
    }

    DateTime? storyDate;
    try {
      storyDate = DateTime.parse(createdAtStr);
    } catch (e) {
      removeStoryFromChat(message);
      return;
    }

    final isExpired = DateTime.now().difference(storyDate).inHours >= 24;
    if (isExpired) {
      removeStoryFromChat(message);
      return;
    }

    if (story.id == null) {
      removeStoryFromChat(message);
      return;
    }

    final user = User(
      id: story.userId,
      username: story.user?.username ?? '',
      fullname: story.user?.fullname ?? '',
      profilePhoto: story.user?.profilePhoto ?? '',
      isVerify: story.user?.isVerify,
      bio: story.user?.bio ?? '',
      stories: [story],
    );

    Get.bottomSheet(
      StoryViewSheet(
        stories: [user],
        userIndex: 0,
        onUpdateDeleteStory: (_) {},
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      useRootNavigator: true,
    );
  }

  void _addUsersFirebaseFireStore() async {
    DocumentReference myUserRef = collectionUsersRef.doc(myUser?.id.toString());
    DocumentReference otherUserRef =
        collectionUsersRef.doc(conversationUser.value.userId.toString());

    DocumentSnapshot isMyUserExist = await myUserRef.get();
    DocumentSnapshot isOtherUserExist = await otherUserRef.get();

    if (myUser != null) {
      if (isMyUserExist.exists) {
        myUserRef.update(myUser!.appUser.toJson());
      } else {
        myUserRef.set(myUser!.appUser.toJson());
      }
    }
    if (otherUser != null) {
      if (isOtherUserExist.exists) {
        otherUserRef.update(otherUser!.appUser.toJson());
      } else {
        otherUserRef.set(otherUser!.appUser.toJson());
      }
    }
  }
}

final playerWaveStyle = PlayerWaveStyle(
    fixedWaveColor: ColorRes.bgGrey,
    spacing: 3,
    waveThickness: 1.5,
    scaleFactor: 50,
    liveWaveGradient: StyleRes.wavesGradient);

class PlayerValue {
  PlayerState state;
  int id;

  PlayerValue({required this.state, required this.id});
}
