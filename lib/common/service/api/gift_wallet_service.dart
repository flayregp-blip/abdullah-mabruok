import 'package:shortzz/common/service/api/api_service.dart';
import 'package:shortzz/common/service/utils/params.dart';
import 'package:shortzz/common/service/utils/web_service.dart';
import 'package:shortzz/model/general/status_model.dart';
import 'package:shortzz/model/gift_wallet/withdraw_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/app_res.dart';

class GiftWalletService {
  GiftWalletService._();

  static final GiftWalletService instance = GiftWalletService._();

  Future<StatusModel> sendGift({int? userId, int? giftId}) async {
    StatusModel response = await ApiService.instance.call(
        url: WebService.giftWallet.sendGift,
        fromJson: StatusModel.fromJson,
        param: {Params.userId: userId, Params.giftId: giftId});
    return response;
  }

  Future<List<Withdraw>> fetchMyWithdrawalRequest({int? lastItemId}) async {
    WithdrawModel response = await ApiService.instance.call(
        url: WebService.giftWallet.fetchMyWithdrawalRequest,
        fromJson: WithdrawModel.fromJson,
        param: {
          Params.limit: AppRes.paginationLimit,
          Params.lastItemId: lastItemId,
        });

    return response.data ?? [];
  }

  Future<StatusModel> submitWithdrawalRequest(
      {required String coins,
      required String gateway,
      required String account}) async {
    StatusModel response = await ApiService.instance.call(
        url: WebService.giftWallet.submitWithdrawalRequest,
        fromJson: StatusModel.fromJson,
        param: {
          Params.coins: coins,
          Params.gateway: gateway,
          Params.account: account
        });

    return response;
  }

  Future<User?> buyCoins({required int id, String? purchasedAt}) async {
    UserModel response = await ApiService.instance.call(
        url: WebService.giftWallet.buyCoins,
        fromJson: UserModel.fromJson,
        param: {
          Params.coinPackageId: id,
          Params.purchasedAt: purchasedAt,
        });
    if (response.status == true) {
      return response.data;
    }
    return null;
  }
}
