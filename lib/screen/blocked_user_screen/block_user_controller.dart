import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/controller/follow_controller.dart';
import 'package:shortzz/common/enum/chat_enum.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/confirmation_dialog.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/firebase_const.dart';

class BlockUserController extends BaseController {
  void blockUser(User? user, Function() completion) {
    Get.bottomSheet(
        ConfirmationSheet(
          title: LKey.blockUser.trParams({'username': user?.username ?? ''}),
          description: LKey.blockUserConfirmation.tr,
          positiveText: LKey.block.tr,
          onTap: () async {
            if (user?.isFollowing == true) {
              FollowController followController;
              if (Get.isRegistered<FollowController>(
                  tag: user?.id.toString())) {
                followController =
                    Get.find<FollowController>(tag: user?.id.toString());
                followController.updateUser(user);
              } else {
                followController = Get.put(FollowController(user.obs),
                    tag: user?.id.toString());
              }
              await followController.followUnFollowUser();
            }
            StatusModel response =
                await UserService.instance.blockUser(userId: user?.id ?? -1);
            if (response.status == true) {
              await _updateStatus(user?.id ?? -1, true);
            }
            completion.call();
          },
        ),
        isScrollControlled: true);
  }

  Future<void> unblockUser(User? user, Function() completion) async {
    await Get.bottomSheet(
        ConfirmationSheet(
          title: LKey.unblockUser.trParams({'username': user?.username ?? ''}),
          description: LKey.unblockUserConfirmation.tr,
          positiveText: LKey.unBlock.tr,
          onTap: () async {
            StatusModel response =
                await UserService.instance.unBlockUser(userId: user?.id ?? -1);
            if (response.status == true) {
              completion.call();
              await _updateStatus(user?.id ?? -1, false);
            }
          },
        ),
        isScrollControlled: true);
  }

  Future<void> _updateStatus(int userId, bool isBlocked) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? myUser = SessionManager.instance.getUser();
    DocumentReference documentSender = db
        .collection(FirebaseConst.users)
        .doc(myUser?.id.toString())
        .collection(FirebaseConst.usersList)
        .doc(userId.toString());

    DocumentReference documentReceiver = db
        .collection(FirebaseConst.users)
        .doc(userId.toString())
        .collection(FirebaseConst.usersList)
        .doc(myUser?.id.toString());

    if ((await documentSender.get()).exists) {
      await documentSender.update({
        FirebaseConst.iBlocked: isBlocked,
        FirebaseConst.requestType: UserRequestAction.block.title,
      });
    }

    if ((await documentReceiver.get()).exists) {
      await documentReceiver.update({
        FirebaseConst.iAmBlocked: isBlocked,
        FirebaseConst.requestType: UserRequestAction.block.title,
      });
    }
  }
}
