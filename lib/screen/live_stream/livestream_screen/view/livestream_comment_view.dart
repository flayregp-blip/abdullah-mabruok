import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/livestream/app_user.dart';
import 'package:shortzz/model/livestream/livestream.dart';
import 'package:shortzz/model/livestream/livestream_comment.dart';
import 'package:shortzz/screen/live_stream/livestream_screen/livestream_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/color_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class LiveStreamCommentView extends StatelessWidget {
  final LivestreamScreenController controller;

  const LiveStreamCommentView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
          blackPure(context),
          blackPure(context).withValues(alpha: .6),
          blackPure(context).withValues(alpha: .1),
        ], stops: const [
          .0,
          .3,
          .5
        ]).createShader(bounds);
      },
      blendMode: BlendMode.dstOut,
      child: Obx(() {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          itemCount: controller.comments.length,
          reverse: true,
          shrinkWrap: true,
          primary: false,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            LivestreamComment comment = controller.comments[index];
            comment.bindCommentUser();
            return Obx(() {
              AppUser? senderUser = comment.senderUserRx.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImage(
                      size: const Size(38, 38),
                      image: senderUser?.profile?.addBaseURL(),
                      fullName: senderUser?.fullname,
                      strokeWidth: 2,
                      strokeColor: whitePure(context).withValues(alpha: .5),
                      isStokeOutSide: true,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3,
                        children: [
                          FullNameWithBlueTick(
                            username: senderUser?.username,
                            isVerify: senderUser?.isVerify,
                            fontColor: whitePure(context),
                            opacity: 0.7,
                            fontSize: 12,
                            iconSize: 18,
                          ),
                          _buildCommentContent(context, comment)
                        ],
                      ),
                    )
                  ],
                ),
              );
            });
          },
        );
      }),
    );
  }

  Widget _buildCommentContent(BuildContext context, LivestreamComment comment) {
    switch (comment.commentType) {
      case null:
        return const SizedBox();
      case LivestreamCommentType.request:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LKey.requestingToJoinTheStream.tr,
              style: TextStyleCustom.outFitRegular400(color: whitePure(context).withValues(alpha: .80)),
            ),
            const SizedBox(height: 5),
            Obx(() {
              AppUser? senderUser = comment.senderUserRx.value;
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      controller.handleRequestResponse(user: senderUser, isRefused: true, comment: comment);
                    },
                    child: Container(
                      height: 26,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: whitePure(context).withValues(alpha: .2), borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: Text(LKey.refuse.tr,
                          style: TextStyleCustom.outFitRegular400(fontSize: 13, color: bgGrey(context))),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      controller.handleRequestResponse(user: senderUser, isRefused: false, comment: comment);
                    },
                    child: Container(
                      height: 26,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: whitePure(context),
                      ),
                      alignment: Alignment.center,
                      child: Text(LKey.accept.tr,
                          style: TextStyleCustom.outFitRegular400(fontSize: 13, color: textDarkGrey(context))),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      case LivestreamCommentType.text:
        return Text(comment.comment?.tr ?? '',
            style: TextStyleCustom.outFitRegular400(color: whitePure(context).withValues(alpha: .80)));
      case LivestreamCommentType.gift:
        if (comment.gift == null) {
          return const SizedBox();
        }
        return Obx(() {
          Livestream stream = controller.liveData.value;
          bool isBattleView = stream.type == LivestreamType.battle;
          bool isHost = comment.receiverId == stream.hostId;
          Color bgColor = isBattleView
              ? (isHost ? Colors.red : ColorRes.battleProgressColor)
              : themeColor(context).withValues(alpha: .5);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Row(
                children: [
                  CustomImage(
                      size: const Size(50, 50),
                      image: comment.gift?.image?.addBaseURL() ?? '',
                      cornerSmoothing: 0,
                      radius: 10,
                      isShowPlaceHolder: true),
                  const SizedBox(width: 5),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: const BoxConstraints(minWidth: 50),
                    decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: SmoothBorderRadius(cornerRadius: 30, cornerSmoothing: 1),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: .3), strokeAlign: BorderSide.strokeAlignInside)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Image.asset(AssetRes.icCoin, height: 18, width: 18),
                        Text((comment.gift?.coinPrice ?? 0).numberFormat,
                            style: TextStyleCustom.outFitRegular400(color: whitePure(context)))
                      ],
                    ),
                  )
                ],
              ),
              if (!isBattleView)
                Text('To : ${comment.receiverUser?.username ?? ''}',
                    style: TextStyleCustom.outFitLight300(color: Colors.white.withValues(alpha: .7), fontSize: 12))
            ],
          );
        });
      case LivestreamCommentType.joined:
        return Text(LKey.joinedTheStream.tr,
            style: TextStyleCustom.outFitRegular400(color: whitePure(context).withValues(alpha: .80)));
      case LivestreamCommentType.joinedCoHost:
        return Text(LKey.joinedAsACoHost.tr,
            style: TextStyleCustom.outFitRegular400(color: whitePure(context).withValues(alpha: .80)));
    }
  }
}
