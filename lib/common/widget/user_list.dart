import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/common/widget/full_name_with_blue_tick.dart';
import 'package:shortzz/common/widget/load_more_widget.dart';
import 'package:shortzz/common/widget/loader_widget.dart';
import 'package:shortzz/common/widget/no_data_widget.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class UserList<T> extends StatelessWidget {
  final RxList<T> users;
  final Function(T user) onTap;
  final Future<void> Function()? loadMore;
  final String Function(T) getProfilePhoto;
  final String Function(T) getUserName;
  final String Function(T) getFullName;
  final int Function(T) getVerified;
  final RxBool isLoading;

  const UserList(
      {super.key,
      required this.onTap,
      this.loadMore,
      required this.users,
      required this.isLoading,
      required this.getProfilePhoto,
      required this.getUserName,
      required this.getFullName,
      required this.getVerified});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => isLoading.value && users.isEmpty
          ? const LoaderWidget()
          : LoadMoreWidget(
              loadMore: loadMore ?? () async {},
              child: NoDataView(
                showShow: !isLoading.value && users.isEmpty,
                title: LKey.userListEmptyTitle.tr,
                description: LKey.userListEmptyDescription.tr,
                child: ListView.builder(
                    itemCount: users.length,
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 10, right: 10),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserCard(
                        onTap: () => onTap(user),
                        fullName: getFullName(user),
                        profilePhoto: getProfilePhoto(user),
                        userName: getUserName(user),
                        isVerified: getVerified(user),
                      );
                    }),
              ),
            ),
    );
  }
}

class UserCard<T> extends StatelessWidget {
  final VoidCallback onTap;
  final String? profilePhoto;
  final String? userName;
  final String? fullName;
  final int isVerified;

  const UserCard(
      {super.key,
      required this.onTap,
      required this.profilePhoto,
      required this.userName,
      required this.fullName,
      this.isVerified = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CustomImage(
                    size: const Size(40, 40),
                    image: profilePhoto?.addBaseURL(),
                    fullName: fullName),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FullNameWithBlueTick(
                          username: userName,
                          fontSize: 13,
                          iconSize: 14,
                          isVerify: isVerified),
                      Text(
                        fullName ?? '',
                        style: TextStyleCustom.outFitLight300(
                            color: textLightGrey(context)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const CustomDivider(color: Colors.transparent)
      ],
    );
  }
}
