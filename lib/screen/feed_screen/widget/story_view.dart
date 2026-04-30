import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/gradient_border.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/screen/feed_screen/feed_screen_controller.dart';
import 'package:shortzz/utilities/style_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class StoryView extends StatelessWidget {
  final FeedScreenController controller;

  const StoryView({super.key, required this.controller});

  static const double storySize = 62;
  static const double gradientSize = 68;
  static const double addIconSize = 23;

  @override
  Widget build(BuildContext context) {

    Widget _buildYourStory() {
      return Obx(() {
        User? user = controller.myUser.value;
        bool isStoryAvailable = (user?.stories ?? []).isNotEmpty;
        bool isWatch = isStoryAvailable &&
            (user?.stories ?? []).every((element) {
              return element.isWatchedByMe();
            });
        return Container(
          width: gradientSize,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (isStoryAvailable) {
                    if (user != null) {
                      controller.onWatchStory([user], 0, 'my_story');
                    }
                  } else {
                    controller.onCreateStory();
                  }
                },
                child: Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      width: storySize + 3,
                      height: storySize + 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: !isStoryAvailable
                                ? Colors.transparent
                                : (isWatch
                                    ? disableGrey(context)
                                    : themeAccentSolid(context)),
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignOutside),
                      ),
                      alignment: Alignment.center,
                      child: _buildImage(user?.profilePhoto?.addBaseURL() ?? '',
                          size: storySize + (!isStoryAvailable ? 3 : 0),
                          fullname: user?.fullname),
                    ),
                    InkWell(
                      onTap: controller.onCreateStory,
                      child: Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          height: addIconSize,
                          width: addIconSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeAccentSolid(context),
                            border:
                                Border.all(color: whitePure(context), width: 2),
                          ),
                          child: Icon(Icons.add_rounded,
                              color: whitePure(context), size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                LKey.you.tr,
                style: TextStyleCustom.outFitRegular400(
                    fontSize: 13, color: blackPure(context)),
              ),
            ],
          ),
        );
      });
    }

    Widget _buildOtherStory(List<User> users, int index) {
      User? user = users[index];
      bool isStoryAvailable = (user.stories ?? []).isNotEmpty;
      bool isWatch = isStoryAvailable &&
          (user.stories ?? []).every((element) {
            return element.isWatchedByMe();
          });
      return Container(
        width: gradientSize,
        height: gradientSize,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GradientBorder(
              gradient: isWatch
                  ? StyleRes.disabledGreyGradient()
                  : StyleRes.themeGradient,
              strokeWidth: 2,
              radius: 90,
              onPressed: () =>
                  controller.onWatchStory(users, index, 'other_story'),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: _buildImage(
                    users[index].profilePhoto?.addBaseURL() ?? '',
                    size: storySize,
                    fullname: users[index].fullname),
              ),
            ),
            Expanded(
              child: Text(
                users[index].username ?? '',
                style: TextStyleCustom.outFitRegular400(fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 85,
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          _buildYourStory(),
          Expanded(
            child: Obx(() {
              List<User> stories = controller.stories;
              return ListView.builder(
                itemCount: stories.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) {
                  return _buildOtherStory(stories, index);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String url, {String? fullname, double size = 62}) {
    return CustomImage(
      size: Size(size, size),
      image: url,
      strokeWidth: 0,
      fit: BoxFit.cover,
      fullName: fullname,
    );
  }
}
