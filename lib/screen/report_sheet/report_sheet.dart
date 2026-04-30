import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/custom_drop_down.dart';
import 'package:shortzz/common/widget/privacy_policy_text.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/screen/report_sheet/report_sheet_controller.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum ReportType { post, user }

class ReportSheet extends StatelessWidget {
  final int? id;
  final ReportType reportType;

  const ReportSheet({super.key, this.id, required this.reportType});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportSheetController(id ?? -1, reportType));
    return Container(
      margin: EdgeInsets.only(top: AppBar().preferredSize.height * 2.5),
      decoration: ShapeDecoration(
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.vertical(
              top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1)),
        ),
        color: scaffoldBackgroundColor(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetTopView(
              title: LKey.reportPost.trParams({
                    'reportType': reportType == ReportType.post
                        ? LKey.post.tr
                        : LKey.user.tr
                  }).capitalize ??
                  ''),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    LKey.reason.tr,
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 17, color: textDarkGrey(context)),
                  ),
                ),
                Obx(
                  () {
                    final selected = controller.selectedValue.value;
                    final reportList = controller.reports;
                    if (reportList.isEmpty) {
                      return Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        color: bgLightGrey(context),
                        width: double.infinity,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(AppRes.emptyReportReason,
                            style: TextStyleCustom.outFitLight300(
                              fontSize: 17,
                              color: textLightGrey(context),
                            )),
                      );
                    }
                    return CustomDropDownBtn(
                      items: reportList,
                      selectedValue: reportList.firstWhere(
                          (e) => e.id == selected?.id,
                          orElse: () => reportList.first),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedValue.value = value;
                        }
                      },
                      getTitle: (p0) => p0.title ?? '',
                      height: 50,
                      width: double.infinity,
                      isExpanded: true,
                      menuMaxHeight: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      bgColor: bgLightGrey(context),
                      style: TextStyleCustom.outFitLight300(
                          fontSize: 17, color: textLightGrey(context)),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    LKey.description.tr,
                    style: TextStyleCustom.outFitRegular400(
                        fontSize: 17, color: textDarkGrey(context)),
                  ),
                ),
                Container(
                  color: bgLightGrey(context),
                  child: TextField(
                      controller: controller.descriptionController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          constraints: const BoxConstraints(
                              minHeight: 170, maxHeight: 170),
                          contentPadding: const EdgeInsets.all(15),
                          hintText: LKey.descriptionHere.tr,
                          hintStyle: TextStyleCustom.outFitLight300(
                              fontSize: 17, color: textLightGrey(context))),
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      style: TextStyleCustom.outFitLight300(
                          fontSize: 17, color: textLightGrey(context))),
                ),
                const SizedBox(height: 30),
                TextButtonCustom(
                  onTap: controller.onReportSubmit,
                  title: LKey.submit.tr,
                  backgroundColor: textDarkGrey(context),
                  titleColor: whitePure(context),
                ),
                SizedBox(height: AppBar().preferredSize.height),
                const PrivacyPolicyText()
              ],
            ),
          )),
        ],
      ),
    );
  }
}
