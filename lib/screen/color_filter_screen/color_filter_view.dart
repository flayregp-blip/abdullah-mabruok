import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/screen/color_filter_screen/widget/color_filtered.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class ColorFiltersView extends StatefulWidget {
  final Function(List<double> filter) onPageChanged;
  final String? image;

  const ColorFiltersView({super.key, required this.onPageChanged, this.image});

  @override
  State<ColorFiltersView> createState() => _ColorFiltersViewState();
}

class _ColorFiltersViewState extends State<ColorFiltersView> {
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: .2, keepPage: true);

  List<Filters> get filtersList => filters;

  void onPageChanged(int index) {
    HapticManager.shared.light();
    widget.onPageChanged.call(filtersList[index].colorFilter);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: filtersList.length,
            itemBuilder: (context, index) {
              Filters filter = filtersList[index];
              bool isZeroIndex = index == 0;
              return InkWell(
                onTap: () {
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.linear);
                  onPageChanged(index);
                },
                child: AnimatedBuilder(
                  animation: pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (pageController.position.haveDimensions) {
                      value = pageController.page! - index;
                    } else {
                      value = 0.0 - index;
                    }

                    value = (1 - (value.abs() * 0.3)).clamp(0.6, 1.0);
                    bool isSelected = value > .8;
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : whitePure(context).withValues(alpha: 0.3),
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isZeroIndex ? Colors.transparent : Colors.white,
                            image: isZeroIndex
                                ? null
                                : widget.image == null ||
                                        (widget.image ?? '').isEmpty
                                    ? DecorationImage(
                                        image: const AssetImage(
                                            AssetRes.greyPicture),
                                        fit: BoxFit.cover,
                                        colorFilter:
                                            filter.colorFilter.isNotEmpty
                                                ? ColorFilter.matrix(
                                                    filter.colorFilter)
                                                : null)
                                    : _decorationImage(filter),
                          ),
                          child: isZeroIndex
                              ? Container(
                                  margin: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    AssetRes.icNoFilter,
                                    height: 50,
                                    width: 50,
                                  ),
                                )
                              : widget.image == null
                                  ? ClipOval(
                                      child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 1.2, sigmaY: 1.2),
                                          child: Container()),
                                    )
                                  : const SizedBox(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          IgnorePointer(
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: whitePure(context), width: 3)),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage? _decorationImage(Filters filter) {
    return DecorationImage(
      image: FileImage(File(widget.image ?? '')),

      // Replace with actual image source if required
      colorFilter: filter.colorFilter.isNotEmpty
          ? ColorFilter.matrix(filter.colorFilter)
          : null,
      fit: BoxFit.cover,
    );
  }
}
