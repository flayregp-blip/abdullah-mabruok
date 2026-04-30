import 'package:get/get.dart';
import 'package:shortzz/common/controller/firebase_firestore_controller.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/utilities/app_res.dart';

class Livestream {
  int? watchingCount;
  String? description;
  LivestreamType? type;
  BattleType? battleType;
  int battleDuration = AppRes.battleDurationInMinutes;
  int? isRestrictToJoin;
  int? hostViewID;
  String? roomID;
  int? likeCount;
  int? hostId;
  List<int>? coHostIds;
  AppUser? hostUser;
  List<AppUser>? coHostUsers;
  int? createdAt;
  int? battleCreatedAt;
  int? isDummyLive;
  String? dummyUserLink;

  Livestream(
      {this.watchingCount,
      this.description,
      this.type,
      this.battleType,
      this.isRestrictToJoin,
      this.hostViewID,
      this.roomID,
      this.likeCount,
      this.hostId,
      this.coHostIds,
      this.createdAt,
      this.battleCreatedAt,
      this.isDummyLive,
      this.dummyUserLink,
      this.battleDuration = AppRes.battleDurationInMinutes});

  Livestream.fromJson(Map<String, dynamic> json) {
    type = LivestreamType.fromString(json['type']);
    battleType = BattleType.fromString(json['battle_type']);
    watchingCount = json['watching_count'];
    description = json['description'];
    isRestrictToJoin = json['is_restrict_to_join'];
    hostViewID = json['host_view_id'];
    roomID = json['room_id'];
    likeCount = json['like_count'];
    hostId = json['host_id'];
    coHostIds = json['co-host_ids'].cast<int>();
    createdAt = json['created_at'];
    battleCreatedAt = json['battle_created_at'];
    isDummyLive = json['is_dummy_live'];
    dummyUserLink = json['dummy_user_link'];
    battleDuration = json['battle_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['watching_count'] = watchingCount;
    data['description'] = description;
    data['type'] = type?.value;
    data['battle_type'] = battleType?.value;
    data['is_restrict_to_join'] = isRestrictToJoin;
    data['host_view_id'] = hostViewID;
    data['room_id'] = roomID;
    data['like_count'] = likeCount;
    data['host_id'] = hostId;
    data['co-host_ids'] = coHostIds;
    data['created_at'] = createdAt;
    data['battle_created_at'] = battleCreatedAt;
    data['is_dummy_live'] = isDummyLive;
    data['dummy_user_link'] = dummyUserLink;
    data['battle_duration'] = battleDuration;
    return data;
  }

  List<AppUser> getAllUsers(List<AppUser> users) {
    AppUser? hostUser =
        users.firstWhereOrNull((element) => element.userId == hostId);
    final coHostUsers = coHostIds
            ?.map((id) => users.firstWhereOrNull((user) => user.userId == id))
            .whereType<AppUser>()
            .toList() ??
        [];

    final allUsers = [if (hostUser != null) hostUser, ...coHostUsers];
    return allUsers;
  }

  AppUser? getHostUser(List<AppUser> users) {
    final controller = Get.find<FirebaseFirestoreController>();
    AppUser? hostUser = controller.users
        .firstWhereOrNull((element) => element.userId == hostId);
    return hostUser;
  }

  List<AppUser> getCoHostUsers(List<AppUser> users) {
    final coHostUsers = coHostIds
            ?.map((id) => users.firstWhereOrNull((user) => user.userId == id))
            .whereType<AppUser>()
            .toList() ??
        [];
    return coHostUsers;
  }
}

enum LivestreamType {
  livestream('LIVESTREAM'),
  battle('BATTLE'),
  dummy('DUMMY');

  final String value;

  const LivestreamType(this.value);

  static LivestreamType fromString(String value) {
    return LivestreamType.values.firstWhereOrNull((e) => e.value == value) ??
        LivestreamType.livestream;
  }
}

enum BattleType {
  initiate('INITIATE'),
  waiting('WAITING'),
  running('RUNNING'),
  end('END');

  final String value;

  const BattleType(this.value);

  static BattleType fromString(String? value) {
    return BattleType.values.firstWhereOrNull((e) => e.value == value) ??
        BattleType.initiate;
  }
}
