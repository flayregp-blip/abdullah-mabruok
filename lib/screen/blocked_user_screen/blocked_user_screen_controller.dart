import 'package:get/get.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/model/user_model/block_user_model.dart';
import 'package:shortzz/screen/blocked_user_screen/block_user_controller.dart';

class BlockedUserScreenController extends BlockUserController {
  RxList<BlockUsers> blockedUsers = RxList<BlockUsers>();

  @override
  void onInit() {
    super.onInit();
    fetchBlockedUsers();
  }

  void fetchBlockedUsers() async {
    isLoading.value = true;
    List<BlockUsers> users = await UserService.instance.fetchMyBlockedUsers();
    blockedUsers.value = users;
    isLoading.value = false;
  }

}
