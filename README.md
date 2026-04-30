# Shortzz 2.0

# Date: 05 February 2026

## Summary

- Fixed Reels Issue

#### Updated Files

- [build.gradle](android/app/build.gradle)
- [firebase_notification_manager.dart](lib/common/manager/firebase_notification_manager.dart)
- [reel_list.dart](lib/common/widget/reel_list.dart)
- [audio_details_screen.dart](lib/screen/audio_details_screen/audio_details_screen.dart)
- [chat_screen_controller.dart](lib/screen/chat_screen/chat_screen_controller.dart)
- [comment_sheet_controller.dart](lib/screen/comment_sheet/comment_sheet_controller.dart)
- [reel_preview_card.dart](lib/screen/create_feed_screen/widget/reel_preview_card.dart)
- [explore_screen_controller.dart](lib/screen/explore_screen/explore_screen_controller.dart)
- [hashtag_screen.dart](lib/screen/hashtag_screen/hashtag_screen.dart)
- [home_screen.dart](lib/screen/home_screen/home_screen.dart)
- [home_screen_controller.dart](lib/screen/home_screen/home_screen_controller.dart)
- [location_screen.dart](lib/screen/location_screen/location_screen.dart)
- [notification_screen_controller.dart](lib/screen/notification_screen/notification_screen_controller.dart)
- [post_view_center.dart](lib/screen/post_screen/widget/post_view_center.dart)
- [post_screen_controller.dart](lib/screen/post_screen/post_screen_controller.dart)
- [profile_page_view.dart](lib/screen/profile_screen/widget/profile_page_view.dart)
- [profile_screen.dart](lib/screen/profile_screen/profile_screen.dart)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reel_page_controller.dart](lib/screen/reels_screen/reel/reel_page_controller.dart)
- [reels_text_field.dart](lib/screen/reels_screen/widget/reels_text_field.dart)
- [reels_top_bar.dart](lib/screen/reels_screen/widget/reels_top_bar.dart)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [saved_post_screen.dart](lib/screen/saved_post_screen/saved_post_screen.dart)
- [search_screen.dart](lib/screen/search_screen/search_screen.dart)

#### Added Files

- [reel_page_type.dart](lib/screen/reels_screen/widget/reel_page_type.dart)

#### Deleted Files

- None

----------------------------------------------------------------------------------------------------

# Date: 28 January 2026

## Summary

- Fixed LiveStream Issue (Reverted stream resource mode from interactive live streaming (OnlyL3) to
  default live streaming (
  CDN))
- Improve Reel Playback

#### Updated Files

- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)
- [build.gradle](android/app/build.gradle)
- [pubspec.yaml](pubspec.yaml)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reels_text_field.dart](lib/screen/reels_screen/widget/reels_text_field.dart)
- [reels_top_bar.dart](lib/screen/reels_screen/widget/reels_top_bar.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [README.md](README.md)

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 22 January 2026

## Summary

- Fixed the reels refreshing issue.

#### Updated Files

- Info.plist
- Runner.xcscheme
- project.pbxproj
- Podfile.lock
- livestream_screen_controller.dart
- reels_screen.dart
- reels_screen_controller.dart
- build.gradle
- settings.gradle

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 07 January 2026

## Summary

- Prevent Reels autoplay when the bottom sheet is open or visibility is low.
- Fixed Story, Reels, Posts Updating issue
- Update dependencies and refactor audio handling

#### Updated Files

- [create_feed_screen.dart](lib/screen/create_feed_screen/create_feed_screen.dart)
- [create_feed_screen_controller.dart](lib/screen/create_feed_screen/create_feed_screen_controller.dart)
- [dashboard_screen.dart](lib/screen/dashboard_screen/dashboard_screen.dart)
- [post_options_sheet.dart](lib/screen/profile_screen/widget/post_options_sheet.dart)
- [profile_screen_controller.dart](lib/screen/profile_screen/profile_screen_controller.dart)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reel_page_controller.dart](lib/screen/reels_screen/reel/reel_page_controller.dart)
- [chat_audio_message.dart](lib/screen/chat_screen/message_type_widget/chat_audio_message.dart)
- [chat_screen_controller.dart](lib/screen/chat_screen/chat_screen_controller.dart)
- [pubspec.yaml](pubspec.yaml)

#### Added Files

- None

#### Deleted Files

- None

----------------------------------------------------------------------------------------------------
# Date: 24 November 2025

## Summary

- Fixed live streaming (CDN) to interactive live streaming.

#### Updated Files

- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)

#### Added Files

- None

#### Deleted Files

- None

----------------------------------------------------------------------------------------------------

# Date: 18 November 2025

## Summary

- Double-tap to like is now working smoothly.
- View counts update correctly.
- Videos stop playing when you navigate away from the feed.

##### Updated Files

- [api_service.dart](lib/common/service/api/api_service.dart)
- [firebase_notification_manager.dart](lib/common/manager/firebase_notification_manager.dart)
- [pubspec.yaml](pubspec.yaml)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reel_page_controller.dart](lib/screen/reels_screen/reel/reel_page_controller.dart)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [build.gradle](android/app/build.gradle)
- [settings.gradle](android/settings.gradle)

----------------------------------------------------------------------------------------------------

# Date: 06 November 2025

## Summary

- Fixed Reel playing issue

##### Updated Files

- api_service.dart
- full_name_with_blue_tick.dart
- profile_page_view.dart
- reel_list.dart
- search_screen.dart
- user_information.dart
- build.gradle
- chat_conversation_user_card.dart
- custom_app_bar.dart
- dashboard_screen.dart
- dashboard_screen_controller.dart
- explore_screen.dart
- hashtag_screen.dart
- hashtag_screen_controller.dart
- home_screen.dart
- home_screen_controller.dart
- languages_keys.dart
- message_screen.dart
- pubspec.yaml
- reel_page.dart
- reel_page_controller.dart
- reel_seek_bar.dart
- reels_screen.dart
- reels_screen_controller.dart
- reels_text_field.dart
- reels_top_bar.dart
- settings.gradle
- share_sheet_widget.dart

#### Added Files

- None

#### Deleted Files

- None

----------------------------------------------------------------------------------------------------

# Date: 03 November 2025

## Summary

- Live streaming mute/unmute audio issue fixed
- Unused Firebase database reads optimized
- Reel pagination limit fixed on Profile and Explore pages
- Story image with audio issue fixed on Android
- Fixed issue where comments could still be pushed when comments were disabled
- Small bug fixes and performance improvements

#### Updated Files

- camera_edit_screen_controller.dart
- chat_center_message_view.dart
- chat_conversation_user_card.dart
- chat_media_message.dart
- chat_thread.dart
- chat_top_profile_view.dart
- create_live_stream_screen_controller.dart
- dashboard_screen.dart
- dashboard_screen_controller.dart
- firebase_firestore_controller.dart
- image_view_screen.dart
- live_stream_search_screen_controller.dart
- livestream_comment.dart
- livestream_comment_view.dart
- livestream_screen_controller.dart
- message_data.dart
- message_screen.dart
- message_screen_controller.dart
- profile_page_view.dart
- reels_screen_controller.dart
- single_post_screen.dart
- Podfile.lock
- pubspec.lock

#### Added Files

- None

#### Deleted Files

- None

----------------------------------------------------------------------------------------------------

# Date: 10 October 2025

## Summary

- Fixed Android 15’s new 16 KB page size requirement.
- Added PostOptionSheet button on Home Screen
- Bug fixes and improvements

#### Updated Files

- [chat_center_message_view.dart](lib/screen/chat_screen/widget/chat_center_message_view.dart)
- [comment_card.dart](lib/screen/comment_sheet/widget/comment_card.dart)
- [gradle-wrapper.properties](android/gradle/wrapper/gradle-wrapper.properties)
- README.md
- [asset_res.dart](lib/utilities/asset_res.dart)
- [post_options_sheet.dart](lib/screen/profile_screen/widget/post_options_sheet.dart)
- [create_live_stream_screen_controller.dart](lib/screen/live_stream/create_live_stream_screen/create_live_stream_screen_controller.dart)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [reels_top_bar.dart](lib/screen/reels_screen/widget/reels_top_bar.dart)
- [reel_list.dart](lib/common/widget/reel_list.dart)
- [search_screen.dart](lib/screen/search_screen/search_screen.dart)
- [settings.gradle](android/settings.gradle)
- [user_information.dart](lib/screen/reels_screen/reel/widget/user_information.dart)
- [search_screen.dart](lib/screen/search_screen/search_screen.dart)
- [.gitignore](.gitignore)
- [build.gradle](android/app/build.gradle)
- [build.gradle](android/build.gradle)
- [pubspec.yaml](pubspec.yaml)
- [deepar.aar](android/app/libs)

#### Added Files

- context_menu_widget.dart+
- [ic_add.png](assets/icons/ic_add.png)

----------------------------------------------------------------------------------------------------

# Date: 26 September 2025

## Summary

- Update pubspec.lock

We have removed **Branch.io** from the project and implemented our **own deep linking solution**
following the
official [Deep Link](https://docs.retrytech.com/shortzz/shortzz_flutter#deeplink_setup).

### Why We Removed Branch.io

Branch.io is significantly more expensive for our use case. By switching to our own deep linking
system, it will impact buyers to save min. $499 every month. Which makes this move truly impactful
helping new startups financially.

### Current Status

- Branch.io SDK and configurations have been completely removed.
- Our own deep linking system is now active and configured as per the official documentation.
- We request all our existing buyers to make updates in source files (Flutter & Laravel both), Make
  database changes & follow the documentation listed above to move to independent Deeplink system.

#### Updated Files

- AppFrameworkInfo.plist
- auth_screen_controller.dart
- custom_drop_down.dart
- pubspec.yaml
- select_language_screen.dart
- settings_screen_controller.dart
- story_text_view.dart
- subscription_manager.dart
- subscription_screen_controller.dart
- AndroidManifest.xml
- AppDelegate.swift
- const_res.dart
- home_screen_controller.dart
- Info.plist
- languages_keys.dart
- live_stream_search_screen.dart
- live_stream_search_screen_controller.dart
- main.dart
- message_screen.dart
- message_screen_controller.dart
- Podfile.lock
- post_screen_controller.dart
- profile_user_header.dart
- pubspec.lock
- pubspec.yaml
- qr_code_screen.dart
- qr_code_screen_controller.dart
- reel_page.dart
- reel_page_controller.dart
- Runner.entitlements
- scan_qr_code_screen.dart
- share_sheet_widget.dart
- share_sheet_widget_controller.dart

#### Added Files

- share_manager.dart

#### Deleted Files

- branch_io_manager.dart

----------------------------------------------------------------------------------------------------

# Date: 06 September 2025

## Summary

- Fixed dummy user login

#### Updated Files

- [session_manager.dart](lib/common/manager/session_manager.dart)
- [user_service.dart](lib/common/service/api/user_service.dart)
- [params.dart](lib/common/service/utils/params.dart)
- [web_service.dart](lib/common/service/utils/web_service.dart)
- [chat_thread.dart](lib/model/chat/chat_thread.dart)
- [auth_screen_controller.dart](lib/screen/auth_screen/auth_screen_controller.dart)
- [on_boarding_screen_controller.dart](lib/screen/on_boarding_screen/on_boarding_screen_controller.dart)
- [select_language_screen.dart](lib/screen/select_language_screen/select_language_screen.dart)
- [splash_screen_controller.dart](lib/screen/splash_screen/splash_screen_controller.dart)
- [main.dart](lib/main.dart)
- [pubspec.yaml](pubspec.yaml)

#### Added Files

- none

#### Deleted Files

- none

---------------------------------------------------------------------------------------------------- 

# Date: 04 September 2025

## Summary

- Fixed dummy user login
- Fixed coin withdrawal issue
- Fixed bugs and made improvements

#### Updated Files

- [api_service.dart](lib/common/service/api/api_service.dart)
- [auth_screen_controller.dart](lib/screen/auth_screen/auth_screen_controller.dart)
- [build.gradle](android/build.gradle)
- [chat_thread.dart](lib/model/chat/chat_thread.dart)
- [dashboard_screen.dart](lib/screen/dashboard_screen/dashboard_screen.dart)
- [dashboard_screen_controller.dart](lib/screen/dashboard_screen/dashboard_screen_controller.dart)
- [google-services.json](android/app/google-services.json)
- [languages_keys.dart](lib/languages/languages_keys.dart)
- [live_stream_search_screen.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen.dart)
- [live_stream_search_screen_controller.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen_controller.dart)
- [livestream.dart](lib/model/livestream/livestream.dart)
- [main.dart](lib/main.dart)
- [message_screen.dart](lib/screen/message_screen/message_screen.dart)
- [message_screen_controller.dart](lib/screen/message_screen/message_screen_controller.dart)
- [notification_service.dart](lib/common/service/api/notification_service.dart)
- [README.md](README.md)
- [request_withdrawal_screen.dart](lib/screen/request_withdrawal_screen/request_withdrawal_screen.dart)
- [settings.gradle](android/settings.gradle)
- [splash_screen_controller.dart](lib/screen/splash_screen/splash_screen_controller.dart)

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 24 July 2025

## Summary

- Fixed bugs and made improvements
- Added identity field to the AppUser class

#### Updated Files

- [app_user.dart](lib/model/livestream/app_user.dart)
- [chat_bottom_action_view.dart](lib/screen/chat_screen/widget/chat_bottom_action_view.dart)
- [google-services.json](android/app/google-services.json)
- [GoogleService-Info.plist](ios/Runner/GoogleService-Info.plist)
- [Info.plist](ios/Runner/Info.plist)
- [live_stream_search_screen.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen.dart)
- [profile_screen_controller.dart](lib/screen/profile_screen/profile_screen_controller.dart)
- [README.md](README.md)
- [settings.gradle](android/settings.gradle)
- [subscription_screen.dart](lib/screen/subscription_screen/subscription_screen.dart)
- [user_extension.dart](lib/common/extensions/user_extension.dart)

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 15 July 2025

## Summary

- Fixed "Sign in with Apple" login issue
- Resolved double increment of reel view count
- Fixed Livestream bugs
- Fixed Follow/Following screen

#### Updated Files

- [pubspec.yaml](pubspec.yaml)
- [auth_screen_controller.dart](lib/screen/auth_screen/auth_screen_controller.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [music_sheet_controller.dart](lib/screen/music_sheet/music_sheet_controller.dart)
- [share_sheet_widget_controller.dart](lib/screen/share_sheet_widget/share_sheet_widget_controller.dart)
- [home_screen_controller.dart](lib/screen/home_screen/home_screen_controller.dart)
- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)
- [livestream_view.dart](lib/screen/live_stream/livestream_screen/view/livestream_view.dart)
- [user_information.dart](lib/screen/reels_screen/reel/widget/user_information.dart)
- [follow_following_screen.dart](lib/screen/follow_following_screen/follow_following_screen.dart)
- [follow_following_screen_controller.dart](lib/screen/follow_following_screen/follow_following_screen_controller.dart)
- [live_stream_user_info_sheet.dart](lib/screen/live_stream/livestream_screen/audience/widget/live_stream_user_info_sheet.dart)
- [livestream_host_screen.dart](lib/screen/live_stream/livestream_screen/host/livestream_host_screen.dart)
- [side_bar_list.dart](lib/screen/reels_screen/reel/widget/side_bar_list.dart)
- [AppDelegate.swift](ios/Runner/AppDelegate.swift)
- [camera_screen_controller.dart](lib/screen/camera_screen/camera_screen_controller.dart)

#### Added Files

- none

#### Deleted Files

- custom.dart

----------------------------------------------------------------------------------------------------

# Date: 03 July 2025

## Summary

- Fixed login issue
- Fixed bugs and made improvements
- Resolved notification issue

#### Updated Files

- [AppDelegate.swift](ios/Runner/AppDelegate.swift)
- [auth_screen_controller.dart](lib/screen/auth_screen/auth_screen_controller.dart)
- [languages_keys.dart](lib/languages/languages_keys.dart)
- [notification_service.dart](lib/common/service/api/notification_service.dart)

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 30 June 2025

## Summary

- Fixed comment count not updating after posting.
- Improved navigation from post/reel detail back to the correct tab.
- Resolved crashes caused by missing languages or onboarding data from admin panel.
- Handled Zego engine configuration errors on dashboard screen.
- Fixed empty Reels screen crash.
- Improved chat notification behavior when app is killed.
- Fixed message tab language not updating properly.
- Resolved text field overlap issues on certain Android devices.
- Improved Live stream stability:
  - Live no longer disappears unexpectedly from the list.
  - Audience visibility and co-host features are now more reliable.
- Fixed Hosts can no longer forcefully turn on the co-host’s camera or microphone during a live
  broadcast. User privacy is now strictly protected.
- Fixed When a user shares a video from the feed, the recipient can now independently like the
  video, even if it was previously liked by the sender.

#### Updated Files

- [app_res.dart](lib/utilities/app_res.dart)
- [asset_res.dart](lib/utilities/asset_res.dart)
- [audio_details_screen.dart](lib/screen/audio_details_screen/audio_details_screen.dart)
- [base_controller.dart](lib/common/controller/base_controller.dart)
- [chat_bottom_action_view.dart](lib/screen/chat_screen/widget/chat_bottom_action_view.dart)
- [chat_conversation_user_card.dart](lib/screen/message_screen/widget/chat_conversation_user_card.dart)
- [chat_screen_controller.dart](lib/screen/chat_screen/chat_screen_controller.dart)
- [chat_top_profile_view.dart](lib/screen/chat_screen/widget/chat_top_profile_view.dart)
- [comment_sheet_controller.dart](lib/screen/comment_sheet/comment_sheet_controller.dart)
- [const_res.dart](lib/utilities/const_res.dart)
- [custom_tab_switcher.dart](lib/common/widget/custom_tab_switcher.dart)
- [dashboard_screen_controller.dart](lib/screen/dashboard_screen/dashboard_screen_controller.dart)
- [explore_screen_controller.dart](lib/screen/explore_screen/explore_screen_controller.dart)
- [firebase_notification_manager.dart](lib/common/manager/firebase_notification_manager.dart)
- [hashtag_screen.dart](lib/screen/hashtag_screen/hashtag_screen.dart)
- [hashtag_screen_controller.dart](lib/screen/hashtag_screen/hashtag_screen_controller.dart)
- [home_screen.dart](lib/screen/home_screen/home_screen.dart)
- [Info.plist](ios/Runner/Info.plist)
- [live_stream_bottom_view.dart](lib/screen/live_stream/livestream_screen/view/live_stream_bottom_view.dart)
- [live_stream_search_screen_controller.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen_controller.dart)
- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)
- [location_service.dart](lib/common/service/location/location_service.dart)
- [location_sheet.dart](lib/screen/create_feed_screen/widget/location_sheet.dart)
- [main.dart](lib/main.dart)
- [notification_screen.dart](lib/screen/notification_screen/notification_screen.dart)
- [notification_service.dart](lib/common/service/api/notification_service.dart)
- [post_card.dart](lib/screen/post_screen/post_card.dart)
- [post_view_center.dart](lib/screen/post_screen/widget/post_view_center.dart)
- [profile_user_header.dart](lib/screen/profile_screen/widget/profile_user_header.dart)
- [pubspec.yaml](pubspec.yaml)
- [README.md](README.md)
- [reel_list.dart](lib/common/widget/reel_list.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [search_screen.dart](lib/screen/search_screen/search_screen.dart)
- [search_screen_controller.dart](lib/screen/search_screen/search_screen_controller.dart)
- [select_language_screen.dart](lib/screen/select_language_screen/select_language_screen.dart)
- [select_language_screen_controller.dart](lib/screen/select_language_screen/select_language_screen_controller.dart)
- [send_gift_sheet.dart](lib/screen/gift_sheet/send_gift_sheet.dart)
- [session_expired_screen.dart](lib/screen/session_expired_screen/session_expired_screen.dart)
- [settings_screen_controller.dart](lib/screen/settings_screen/settings_screen_controller.dart)
- [single_post_screen.dart](lib/screen/post_screen/single_post_screen.dart)
- [splash_screen_controller.dart](lib/screen/splash_screen/splash_screen_controller.dart)
- [string_extension.dart](lib/common/extensions/string_extension.dart)
- [system_notification_page.dart](lib/screen/notification_screen/widget/system_notification_page.dart)
- [url_card.dart](lib/screen/post_screen/widget/url_card.dart)
- [user_information.dart](lib/screen/reels_screen/reel/widget/user_information.dart)
- [user_link_sheet.dart](lib/screen/profile_screen/widget/user_link_sheet.dart)
- [Podfile.lock](ios/Podfile.lock)
- [pubspec.lock](pubspec.lock)
- [chat_post_message.dart](lib/screen/chat_screen/message_type_widget/chat_post_message.dart)
- [firebase_const.dart](lib/utilities/firebase_const.dart)
- [live_stream_user_info_sheet.dart](lib/screen/live_stream/livestream_screen/audience/widget/live_stream_user_info_sheet.dart)
- [livestream_user_state.dart](lib/model/livestream/livestream_user_state.dart)
- [livestream_view.dart](lib/screen/live_stream/livestream_screen/view/livestream_view.dart)
- [members_sheet.dart](lib/screen/live_stream/livestream_screen/widget/members_sheet.dart)
- [post_model.dart](lib/model/post_story)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [share_sheet_widget_controller.dart](lib/screen/share_sheet_widget/share_sheet_widget_controller.dart)
- [user_extension.dart](lib/common/extensions/user_extension.dart)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reel_page_controller.dart](lib/screen/reels_screen/reel/reel_page_controller.dart)

#### Added Files

- none

#### Deleted Files

- [ic_chat_gift.png](assets/icons/ic_chat_gift.png)

----------------------------------------------------------------------------------------------------

# Date: 17 June 2025

## Summary

- fixed horizontal reel issue
- Fixed "App last used at" not updating for users
- Added Branch key in const_res.dart
- Fixed "Access Denied" error for some images (wrong URL)
- fixed Reel issue
- link preview UI change
- Added loader to music sheet & Follow button & block button
- Fixed reply comment not sending
- Set `setLooping(true)` for livestream demo video player
- Fixed notification: tapping it should go to the post, and tapping a photo should go to the user
  profile
- Fixed removed stories older than 24 hours
- fixed the issue where notifications were not being sent in the localized language.

#### Updated Files

- [activity_notification_page.dart](lib/screen/notification_screen/widget/activity_notification_page.dart)
- [api_service.dart](lib/common/service/api/api_service.dart)
- [auth_screen_controller.dart](lib/screen/auth_screen/auth_screen_controller.dart)
- [block_user_controller.dart](lib/screen/blocked_user_screen/block_user_controller.dart)
- [blocked_user_screen.dart](lib/screen/blocked_user_screen/blocked_user_screen.dart)
- [camera_edit_screen_controller.dart](lib/screen/camera_edit_screen/camera_edit_screen_controller.dart)
- [camera_screen_controller.dart](lib/screen/camera_screen/camera_screen_controller.dart)
- [chat_screen_controller.dart](lib/screen/chat_screen/chat_screen_controller.dart)
- [chat_story_reply_message.dart](lib/screen/chat_screen/message_type_widget/chat_story_reply_message.dart)
- [chat_thread.dart](lib/model/chat/chat_thread.dart)
- [comment_card.dart](lib/screen/comment_sheet/widget/comment_card.dart)
- [comment_helper.dart](lib/screen/comment_sheet/helper/comment_helper.dart)
- [comment_sheet_controller.dart](lib/screen/comment_sheet/comment_sheet_controller.dart)
- [const_res.dart](lib/utilities/const_res.dart)
- [create_feed_screen_controller.dart](lib/screen/create_feed_screen/create_feed_screen_controller.dart)
- [dashboard_screen.dart](lib/screen/dashboard_screen/dashboard_screen.dart)
- [dashboard_screen_controller.dart](lib/screen/dashboard_screen/dashboard_screen_controller.dart)
- [firebase_firestore_controller.dart](lib/common/controller/firebase_firestore_controller.dart)
- [firebase_notification_manager.dart](lib/common/manager/firebase_notification_manager.dart)
- [follow_controller.dart](lib/common/controller/follow_controller.dart)
- [follow_following_screen.dart](lib/screen/follow_following_screen/follow_following_screen.dart)
- [follow_following_screen_controller.dart](lib/screen/follow_following_screen/follow_following_screen_controller.dart)
- [home_screen_controller.dart](lib/screen/home_screen/home_screen_controller.dart)
- [Info.plist](ios/Runner/Info.plist)
- [live_stream_search_screen_controller.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen_controller.dart)
- [live_video_player.dart](lib/screen/live_stream/livestream_screen/view/live_video_player.dart)
- [livestream_comment_view.dart](lib/screen/live_stream/livestream_screen/view/livestream_comment_view.dart)
- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)
- [main.dart](lib/main.dart)
- [members_sheet.dart](lib/screen/live_stream/livestream_screen/widget/members_sheet.dart)
- [message_screen.dart](lib/screen/message_screen/message_screen.dart)
- [music_sheet.dart](lib/screen/music_sheet/music_sheet.dart)
- [notification_screen.dart](lib/screen/notification_screen/notification_screen.dart)
- [notification_screen_controller.dart](lib/screen/notification_screen/notification_screen_controller.dart)
- [Podfile.lock](ios/Podfile.lock)
- [post_screen_controller.dart](lib/screen/post_screen/post_screen_controller.dart)
- [post_view_center.dart](lib/screen/post_screen/widget/post_view_center.dart)
- [profile_screen_controller.dart](lib/screen/profile_screen/profile_screen_controller.dart)
- [profile_user_header.dart](lib/screen/profile_screen/widget/profile_user_header.dart)
- [pubspec.yaml](pubspec.yaml)
- [qr_code_screen.dart](lib/screen/qr_code_screen/qr_code_screen.dart)
- [qr_code_screen_controller.dart](lib/screen/qr_code_screen/qr_code_screen_controller.dart)
- [reel_page.dart](lib/screen/reels_screen/reel/reel_page.dart)
- [reel_page_controller.dart](lib/screen/reels_screen/reel/reel_page_controller.dart)
- [reel_seek_bar.dart](lib/screen/reels_screen/reel/widget/reel_seek_bar.dart)
- [reels_screen.dart](lib/screen/reels_screen/reels_screen.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [scan_qr_code_screen.dart](lib/screen/scan_qr_code_screen/scan_qr_code_screen.dart)
- [selected_music_sheet_controller.dart](lib/screen/selected_music_sheet/selected_music_sheet_controller.dart)
- [send_gift_sheet_controller.dart](lib/screen/gift_sheet/send_gift_sheet_controller.dart)
- [session_manager.dart](lib/common/manager/session_manager.dart)
- [settings_screen_controller.dart](lib/screen/settings_screen/settings_screen_controller.dart)
- [splash_screen_controller.dart](lib/screen/splash_screen/splash_screen_controller.dart)
- [text_button_custom.dart](lib/common/widget/text_button_custom.dart)
- [url_meta_data_card.dart](lib/screen/create_feed_screen/widget/url_meta_data_card.dart)
- [user_information.dart](lib/screen/reels_screen/reel/widget/user_information.dart)
- [user_service.dart](lib/common/service/api/user_service.dart)
- [web_service.dart](lib/common/service/utils/web_service.dart)
- README.md

#### Added Files

- network_helper.dart
- url_card.dart
- video_cache_helper.dart

----------------------------------------------------------------------------------------------------

# Date: 17 June 2025

## Summary

- 🐞 Bug fixes and performance improvements.

#### Updated Files

- [ads_controller.dart](lib/common/controller/ads_controller.dart)
- [asset_res.dart](lib/utilities/asset_res.dart)
- [comment_bottom_text_field_view.dart](lib/screen/comment_sheet/widget/comment_bottom_text_field_view.dart)
- [comment_card.dart](lib/screen/comment_sheet/widget/comment_card.dart)
- [custom_drop_down.dart](lib/common/widget/custom_drop_down.dart)
- [explore_screen.dart](lib/screen/explore_screen/explore_screen.dart)
- [firebase_notification_manager.dart](lib/common/manager/firebase_notification_manager.dart)
- [gif_sheet.dart](lib/screen/gif_sheet/gif_sheet.dart)
- [home_screen.dart](lib/screen/home_screen/home_screen.dart)
- [home_screen_controller.dart](lib/screen/home_screen/home_screen_controller.dart))
- [languages_keys.dart](lib/languages/languages_keys.dart)
- [live_stream_search_screen_controller.dart](lib/screen/live_stream/live_stream_search_screen/live_stream_search_screen_controller.dart)
- [livestream_comment.dart](lib/model/livestream/livestream_comment.dart)
- [livestream_screen_controller.dart](lib/screen/live_stream/livestream_screen/livestream_screen_controller.dart)
- [main.dart](lib/main.dart))
- [more_user_sheet.dart](lib/screen/share_sheet_widget/widget/more_user_sheet.dart)
- [post_view_center.dart](lib/screen/post_screen/widget/post_view_center.dart)
- [profile_screen.dart](lib/screen/profile_screen/profile_screen.dart)
- [qr_code_screen.dart](lib/screen/qr_code_screen/qr_code_screen.dart)
- [reels_screen_controller.dart](lib/screen/reels_screen/reels_screen_controller.dart)
- [report_sheet.dart](lib/screen/report_sheet/report_sheet.dart)
- [report_sheet_controller.dart](lib/screen/report_sheet/report_sheet_controller.dart)
- [request_withdrawal_screen.dart](lib/screen/request_withdrawal_screen/request_withdrawal_screen.dart)
- [settings_screen.dart](lib/screen/settings_screen/settings_screen.dart)
- [share_sheet_widget.dart](lib/screen/share_sheet_widget/share_sheet_widget.dart)
- [system_notification_page.dart](lib/screen/notification_screen/widget/system_notification_page.dart)
- [user_information.dart](lib/screen/reels_screen/reel/widget/user_information.dart)
- [video_player_screen.dart](lib/screen/video_player_screen/video_player_screen.dart)

#### Added Files

- none

#### Deleted Files

- none

----------------------------------------------------------------------------------------------------

# Date: 16 June 2025

## Summary

- New Project

#### Updated Files

- none

#### Added Files

- none

#### Deleted Files

- none
