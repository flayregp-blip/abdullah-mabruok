import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/model/general/location_place_model.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class CreateFeedLocationBar extends StatelessWidget {
  final CreateFeedScreenController controller;

  const CreateFeedLocationBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Places? place = controller.selectedLocation.value;

      if (place == null) {
        return const SizedBox();
      }

      return Container(
        height: 47,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(top: 5),
        color: bgLightGrey(context),
        child: Row(
          children: [
            Image.asset(AssetRes.icLocation, height: 17, width: 17),
            const SizedBox(width: 5),
            Expanded(
                child: Text(place.placeTitle,
                    style: TextStyleCustom.outFitLight300(color: textDarkGrey(context)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                controller.selectedLocation.value = null;
              },
              child: Image.asset(AssetRes.icClose,
                  height: 17, width: 17, color: textLightGrey(context)),
            )
          ],
        ),
      );
    });
  }
}
