import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/common_extension.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/context_menu_widget.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ReelList extends StatelessWidget {
  final RxList<Post> reels;
  final ScrollController? controller;
  final RxBool isLoading;
  final bool isPinShow;
  final List<ContextMenuElement>? menus;
  final Future<void> Function() onFetchMoreData;
  final Function(dynamic)? onBackResponse;
  final bool shrinkWrap;
  final Widget? widget;
  final ReelPageType pageType;
  final User? user;
  final String? hashTag;

  const ReelList({
    super.key,
    required this.reels,
    this.controller,
    required this.isLoading,
    this.isPinShow = false,
    this.menus,
    required this.onFetchMoreData,
    this.shrinkWrap = false,
    this.onBackResponse,
    this.widget,
    required this.pageType,
    this.user,
    this.hashTag,
  });

  @override
  Widget build(BuildContext context) {
    return LoadMoreWidget(
      loadMore: onFetchMoreData,
      child: Obx(() {
        if (isLoading.value && reels.isEmpty) {
          return const LoaderWidget();
        }

        return NoDataView(
          title: LKey.noUserReelsTitle.tr,
          description: LKey.noUserReelsDescription.tr,
          showShow: !isLoading.value && reels.isEmpty,
          child: GridView.builder(
            primary: !shrinkWrap,
            shrinkWrap: shrinkWrap,
            itemCount: reels.length,
            padding: EdgeInsets.only(
              left: 1,
              right: 1,
              top: 1,
              bottom: AppBar().preferredSize.height,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              mainAxisExtent: 172,
            ),
            itemBuilder: (context, index) {
              final post = reels[index];
              return ReelGridCardView(
                onTap: () {
                  Get.to(
                    () => ReelsScreen(
                      reels: reels,
                      position: index,
                      onFetchMoreData: onFetchMoreData,
                      widget: widget,
                      pageType: pageType,
                      hashTag: hashTag,
                      user: user,
                    ),
                    preventDuplicates: false,
                  )?.then((value) {
                    onBackResponse?.call(value);
                  });
                },
                post: post,
                isPinShow: isPinShow,
                menus: menus,
              );
            },
          ),
        );
      }),
    );
  }
}

class ReelGridCardView extends StatelessWidget {
  final Post? post;
  final VoidCallback? onTap;
  final bool isPinShow;
  final List<ContextMenuElement>? menus;

  const ReelGridCardView({super.key, this.post, this.onTap, this.isPinShow = false, this.menus});

  @override
  Widget build(BuildContext context) {
    return ContextMenuWidget(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CustomImage(
                size: const Size(172, 172),
                strokeWidth: 0,
                image: post?.thumbnail?.addBaseURL(),
                radius: 0,
                isShowPlaceHolder: true),
            if (post?.isPinned == 1 && isPinShow)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(
                    AssetRes.icPinned,
                    width: 19,
                    height: 19,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AssetRes.icPlay1, height: 15, width: 18),
                  Text(
                    (post?.views?.toInt() ?? 0).numberFormat,
                    style: TextStyleCustom.outFitMedium500(
                      fontSize: 13,
                      color: whitePure(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      menuProvider: (_) {
        if (menus == null || post == null) return Menu(children: []);

        // Pass the post instance into the menu items if required
        return Menu(
          children: menus!.map((element) {
            return MenuAction(
              title: element.title.isEmpty
                  ? (post?.isPinned == 1 ? LKey.unpin.tr : LKey.pin.tr)
                  : element.title,
              callback: () {
                element.onTap?.call(post!); // Pass the post to menu action
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class ContextMenuElement {
  final String title;
  final IconData? icon;
  final Function(Post post)? onTap; // Accepts Post

  ContextMenuElement({required this.title, this.icon, this.onTap});
}
