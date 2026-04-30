import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/common/manager/session_manager.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/theme_blur_bg.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/general/settings_model.dart';
import 'package:shortzz/screen/auth_screen/login_screen.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SessionExpiredScreen extends StatefulWidget {
  final SessionType type;

  const SessionExpiredScreen({super.key, required this.type});

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen> {
  Rx<Setting?> get settings => SessionManager.instance.getSettings().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ThemeBlurBg(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SafeArea(
              child: Column(
                spacing: 20,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(widget.type.icon,
                      height: 150, width: 150, color: whitePure(context)),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      spacing: 20,
                      children: [
                        Text(widget.type.title.tr,
                            style: TextStyleCustom.unboundedRegular400(
                                color: whitePure(context), fontSize: 20)),
                        Obx(() {
                          final helpMail = settings.value?.helpMail ?? '';

                          final description =
                              widget.type.description(value: helpMail).tr;

                          final parts = description.split(helpMail);

                          return RichText(
                            text: TextSpan(
                              style: TextStyleCustom.outFitRegular400(
                                  color: bgGrey(context), fontSize: 17),
                              children: [
                                TextSpan(text: parts.first),
                                TextSpan(
                                    text: helpMail,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        String _url = 'mailto:$helpMail';
                                        _url.lunchUrlWithHttps;
                                      },
                                    style: TextStyleCustom.outFitBold700(
                                        color: bgGrey(context), fontSize: 17)),
                                if (parts.length > 1)
                                  TextSpan(text: parts.last),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  )),
                  TextButtonCustom(
                    onTap: () {
                      switch (widget.type) {
                        case SessionType.freeze:
                          logOutUser();
                          break;
                        case SessionType.unauthorized:
                          SessionManager.instance.clear();
                          Get.off(() => const LoginScreen());
                          break;
                      }
                    },
                    title: widget.type.actionName,
                    backgroundColor: whitePure(context),
                    titleColor: blackPure(context),
                    margin: const EdgeInsets.only(top: 20),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logOutUser() {
    UserService.instance.logoutUser().then((value) {
      if (value.status == true) {
        SessionManager.instance.clear();
        Get.off(() => const LoginScreen());
      } else {
        Loggers.error(value.message);
      }
    });
  }
}

enum SessionType {
  freeze,
  unauthorized;

  String get icon {
    switch (this) {
      case SessionType.freeze:
        return AssetRes.icFreeze;
      case SessionType.unauthorized:
        return AssetRes.icSessionExpired;
    }
  }

  String get title {
    switch (this) {
      case SessionType.freeze:
        return LKey.freezeTitle.tr;
      case SessionType.unauthorized:
        return LKey.sessionExpiredTitle.tr;
    }
  }

  String description({String? value}) {
    switch (this) {
      case SessionType.freeze:
        return LKey.freezeDescription.trParams({'support_mail': value ?? ''});
      case SessionType.unauthorized:
        return LKey.sessionExpiredMessage
            .trParams({'app_name': AppRes.appName});
    }
  }

  String get actionName {
    switch (this) {
      case SessionType.freeze:
        return LKey.logOut.tr;
      case SessionType.unauthorized:
        return LKey.logIn.tr;
    }
  }
}
