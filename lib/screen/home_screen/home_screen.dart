import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/widget/custom_divider.dart';
import 'package:shortzz/screen/home_screen/home_screen_controller.dart';
import 'package:shortzz/screen/reels_screen/reels_screen.dart';
import 'package:shortzz/screen/reels_screen/widget/reel_page_type.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeScreenController());
    return Scaffold(
      backgroundColor: blackPure(context),
      body: Stack(
        children: [
          ReelsScreen(
            pageType: ReelPageType.home,
            reels: controller.reels,
            position: 0,
            isLoading: controller.isLoading,
            onFetchMoreData: () => controller.onRefreshPage(reset: false),
            widget: HomeTopCenterWidget(controller: controller),
            onRefresh: controller.onRefreshPage,
          ),
          Obx(
            () => GestureDetector(
              onTap: !controller.isAnimateTab.value ? null : controller.onAnimationBack,
              child: Container(color: !controller.isAnimateTab.value ? null : Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          SafeArea(
            minimum: EdgeInsets.only(top: AppBar().preferredSize.height * 1.5),
            child: SizeTransition(
              sizeFactor: controller.animation,
              axis: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Center(
                      child: CustomPaint(
                        painter: TrianglePainter(
                            strokeColor: whitePure(context), strokeWidth: 0, paintingStyle: PaintingStyle.fill),
                        child: const SizedBox(height: 9, width: 15),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: ShapeDecoration(
                        color: whitePure(context),
                        shape: SmoothRectangleBorder(
                          borderRadius: SmoothBorderRadius(cornerRadius: 8, cornerSmoothing: 1),
                        ),
                      ),
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: TabType.values.length,
                        itemBuilder: (context, index) {
                          TabType tabType = TabType.values[index];
                          return Obx(() {
                            bool isSelected = controller.selectedReelCategory.value == tabType;
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () => controller.onTabTypeChanged(tabType),
                                  child: Container(
                                    height: 25,
                                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            tabType.title.toUpperCase(),
                                            style: TextStyleCustom.unboundedBold700(
                                                fontSize: 14,
                                                color: isSelected ? textDarkGrey(context) : textLightGrey(context)),
                                          ),
                                        ),
                                        if (isSelected)
                                          Image.asset(AssetRes.icCheckCircle,
                                              color: isSelected ? textDarkGrey(context) : textLightGrey(context),
                                              height: 24,
                                              width: 24),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index < TabType.values.length - 1) const CustomDivider(),
                              ],
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeTopCenterWidget extends StatelessWidget {
  final HomeScreenController controller;

  const HomeTopCenterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.onToggleDropDown,
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(controller.selectedReelCategory.value.title.toUpperCase(),
                style: TextStyleCustom.unboundedBold700(fontSize: 16, color: whitePure(context)))),
            const SizedBox(width: 5),
            Image.asset(AssetRes.icDownArrow, color: whitePure(context), height: 12, width: 12),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
