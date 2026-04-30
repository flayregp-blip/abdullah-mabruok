import 'package:shortzz/common/service/api/api_service.dart';
import 'package:shortzz/common/service/utils/params.dart';
import 'package:shortzz/common/service/utils/web_service.dart';
import 'package:shortzz/model/general/status_model.dart';

class ModeratorService {
  ModeratorService._();

  static final ModeratorService instance = ModeratorService._();

  Future<StatusModel> moderatorDeletePost({int? postId}) async {
    StatusModel result = await ApiService.instance.call(
        url: WebService.moderation.moderatorDeletePost,
        param: {
          Params.postId: postId,
        },
        fromJson: StatusModel.fromJson);
    return result;
  }

  Future<StatusModel> moderatorDeleteStory({int? storyId}) async {
    StatusModel result = await ApiService.instance.call(
        url: WebService.moderation.moderatorDeleteStory,
        param: {
          Params.storyId: storyId,
        },
        fromJson: StatusModel.fromJson);
    return result;
  }

  Future<StatusModel> moderatorFreezeUser({int? userId}) async {
    StatusModel result = await ApiService.instance.call(
        url: WebService.moderation.moderatorFreezeUser,
        param: {
          Params.userId: userId,
        },
        fromJson: StatusModel.fromJson);
    return result;
  }

  Future<StatusModel> moderatorUnFreezeUser({int? userId}) async {
    StatusModel result = await ApiService.instance.call(
        url: WebService.moderation.moderatorUnFreezeUser,
        param: {
          Params.userId: userId,
        },
        fromJson: StatusModel.fromJson);
    return result;
  }
}
