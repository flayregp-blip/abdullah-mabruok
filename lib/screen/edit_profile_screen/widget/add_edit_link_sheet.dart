import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/service/api/user_service.dart';
import 'package:shortzz/common/widget/bottom_sheet_top_view.dart';
import 'package:shortzz/common/widget/text_button_custom.dart';
import 'package:shortzz/common/widget/text_field_custom.dart';
import 'package:shortzz/languages/languages_keys.dart';
import 'package:shortzz/model/user_model/user_model.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/theme_res.dart';

class AddEditLinksSheet extends StatefulWidget {
  final Link? link;
  final LinkType type;
  final Function(Link link) onLinksUpdate;

  const AddEditLinksSheet(
      {super.key, this.link, required this.onLinksUpdate, required this.type});

  @override
  State<AddEditLinksSheet> createState() => _AddEditLinksSheetState();
}

class _AddEditLinksSheetState extends State<AddEditLinksSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  BaseController baseController = BaseController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.link?.title ?? '');
    linkController = TextEditingController(text: widget.link?.url ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          color: whitePure(context),
          shape: const SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius.vertical(
                  top: SmoothRadius(cornerRadius: 40, cornerSmoothing: 1)))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BottomSheetTopView(
                title:
                    widget.link == null ? LKey.addLink.tr : LKey.editLink.tr),
            TextFieldCustom(
              controller: titleController,
              title: LKey.title.tr,
            ),
            TextFieldCustom(
              controller: linkController,
              title: LKey.link.tr,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 10),
            TextButtonCustom(
                onTap: _onSave,
                title: LKey.save.tr,
                titleColor: whitePure(context),
                backgroundColor: blackPure(context)),
            SizedBox(height: AppBar().preferredSize.height),
          ],
        ),
      ),
    );
  }

  void _onSave() async {
    if (titleController.text.trim().isEmpty) {
      return baseController.showSnackBar(LKey.urlTitleEmpty.tr);
    }
    if (linkController.text.trim().isEmpty) {
      return baseController.showSnackBar(LKey.urlEmpty.tr);
    }

    if (!AppRes.urlRegex.hasMatch(linkController.text.trim())) {
      return baseController.showSnackBar(LKey.validUrl.tr);
    }

    baseController.showLoader();
    var response = await UserService.instance.addEditDeleteUserLink(
        title: titleController.text.trim(),
        linkId: widget.link?.id?.toInt(),
        urlLink: linkController.text.trim(),
        linkType: widget.type);
    baseController.stopLoader();
    Get.back();

    switch (widget.type) {
      case LinkType.add:
        widget.onLinksUpdate((response.data ?? []).last);
      case LinkType.edit:
        Link link = (response.data ?? [])
            .firstWhere((element) => element.id == widget.link?.id);
        widget.onLinksUpdate(link);
      case LinkType.delete:
    }
  }
}

enum LinkType { add, edit, delete }
