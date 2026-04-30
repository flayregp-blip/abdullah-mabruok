import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/model/misc/admin_notification_model.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class SystemNotificationPage extends StatelessWidget {
  final AdminNotificationData data;

  const SystemNotificationPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: bgLightGrey(context),
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.image != null)
            ClipSmoothRect(
              radius: SmoothBorderRadius(cornerRadius: 5, cornerSmoothing: 1),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CustomImage(
                  image: data.image?.addBaseURL(),
                  size: const Size(double.infinity, 200),
                  fit: BoxFit.cover,
                  radius: 5,
                  cornerSmoothing: 1,
                  isShowPlaceHolder: true,
                ),
              ),
            ),
          Text(data.title ?? '',
              style: TextStyleCustom.outFitMedium500(
                  fontSize: 16, color: textDarkGrey(context))),
          DetectableText(
            text: data.description ?? '',
            basicStyle: TextStyleCustom.outFitLight300(
                fontSize: 15, color: textLightGrey(context)),
            detectionRegExp:
                detectionRegExp(atSign: false, hashtag: false, url: true)!,
            detectedStyle: TextStyleCustom.outFitMedium500(
                color: themeAccentSolid(context)),
            onTap: (p0) {
              p0.lunchUrlWithHttps;
            },
          ),
          const SizedBox(height: 10),
          Text(
            (data.createdAt ?? '').formatDate,
            style: TextStyleCustom.outFitLight300(
                fontSize: 12, color: textLightGrey(context)),
          ),
        ],
      ),
    );
  }
}
