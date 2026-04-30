import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/model/livestream/livestream_user_state.dart';
import 'package:shortzz/model/user_model/user_model.dart';

extension UserExtension on User {
  AppUser get appUser {
    return AppUser(
        username: username,
        userId: id,
        profile: profilePhoto,
        fullname: fullname,
        isVerify: isVerify,
        identity: identity);
  }

  Livestream livestream({
    required LivestreamType type,
    required int time,
    String? description,
    int? restrictToJoin = 1,
    int? hostViewId = -1,
    int? isDummyLive = 0,
    String? dummyUserLink = '',
  }) {
    return Livestream(
        description: (description ?? '').trim(),
        isRestrictToJoin: restrictToJoin,
        type: type,
        watchingCount: 0,
        roomID: id.toString(),
        hostViewID: hostViewId,
        likeCount: 0,
        coHostIds: [],
        hostId: id,
        createdAt: time,
        battleType: BattleType.initiate,
        isDummyLive: isDummyLive,
        dummyUserLink: dummyUserLink);
  }

  LivestreamUserState streamState(
      {LivestreamUserType stateType = LivestreamUserType.audience,
      required int time}) {
    return LivestreamUserState(
        type: stateType,
        userId: id ?? -1,
        totalBattleCoin: 0,
        currentBattleCoin: 0,
        liveCoin: 0,
        followersGained: [],
        joinStreamTime: time);
  }
}
