import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shortzz/common/controller/base_controller.dart';
import 'package:shortzz/common/functions/generate_color.dart';
import 'package:shortzz/common/manager/logger.dart';
import 'package:shortzz/screen/camera_edit_screen/camera_edit_screen_controller.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/story_text_font_widget.dart';
import 'package:shortzz/screen/camera_edit_screen/text_story/widget/text_editor_sheet.dart';
import 'package:shortzz/utilities/app_res.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

enum BgColorType { color, gradient }

class StoryTextViewController extends BaseController {
  List<StoryTextEditor> editorList = StoryTextEditor.values;
  List<FontAlign> alignList = FontAlign.values;

  RxList<GoogleFontFamily> fontFamilyList = <GoogleFontFamily>[].obs;
  RxList<GoogleFontFamily> filteredFontFamilyList = <GoogleFontFamily>[].obs;

  RxList<GoogleFontFamily> outerFontFamilyList = <GoogleFontFamily>[].obs;
  Rx<Color> selectedColor = Rx(GenerateColor.instance.fontColor.first);
  RxInt selectedIndex = 0.obs;

  RxList<TextWidgetData> textWidgets = <TextWidgetData>[].obs;

  Rx<StoryTextEditor> selectorEditorIndex = Rx<StoryTextEditor>(StoryTextEditor.font);
  Rx<GoogleFontFamily?> selectedFontFamily = Rx<GoogleFontFamily?>(null);
  GlobalKey previewContainer = GlobalKey();
  Rx<FontAlign> selectedAlignment = Rx(FontAlign.center);
  RxDouble selectedTextOpacity = 1.0.obs;
  RxDouble selectedFontSize = AppRes.minFontSize.obs;

  CameraEditScreenController cameraEditController;

  StoryTextViewController(this.cameraEditController);
  @override
  void onReady() {
    super.onReady();
    cameraEditController.onNewTexFieldAdd = () {
      openTextEditor();
    };
    _addFontFamilyList();
  }

  @override
  void onClose() {
    super.onClose();
    releaseAllFonts();
  }

  void _addFontFamilyList() {
    final googleFontsMap = GoogleFonts.asMap();

    // Load only the first 10 fonts to reduce memory usage
    outerFontFamilyList.assignAll(googleFontsMap.entries
        .take(10)
        .map((font) => GoogleFontFamily(fontName: font.key))
        .toList());

    // Keep the full font list empty initially, load only when required
    fontFamilyList.clear();
    filteredFontFamilyList.clear();

    Future.delayed(const Duration(seconds: 1), () {
      loadAllFonts();
    });
  }

  void loadAllFonts() {
    if (fontFamilyList.isEmpty) {
      final googleFontsMap = GoogleFonts.asMap();

      // Convert map keys to a list to reduce object creation
      final fontList = googleFontsMap.keys
          .map((fontName) => GoogleFontFamily(fontName: fontName))
          .toList(growable: false); // Use non-growable list to reduce memory overhead
      Loggers.success(fontList.length);
      fontFamilyList.assignAll(fontList);
      filteredFontFamilyList.assignAll(fontList);
    }
  }

  void openTextEditor() {
    resetTextEditorValues();
    Get.bottomSheet<TextWidgetData>(
      TextEditorSheet(data: TextWidgetData()),
      isScrollControlled: true,
      ignoreSafeArea: false,
      enableDrag: false,
      isDismissible: false,
      backgroundColor: blackPure(Get.context!).withValues(alpha: .2),
      barrierColor: blackPure(Get.context!).withValues(alpha: .2),
    ).then((value) {
      if (value != null && value.text.isNotEmpty) {
        textWidgets.add(value);
      }
    });
  }

  void resetTextEditorValues() {
    selectedFontFamily.value = null;
    selectedColor.value = Colors.white;
    selectedAlignment.value = FontAlign.center;
    selectedTextOpacity.value = 1.0;
    selectorEditorIndex.value = StoryTextEditor.font;
  }

  // Helper to create updated text widget data
  TextWidgetData createUpdatedData(TextWidgetData data, String updatedText) {
    return TextWidgetData(
      text: updatedText,
      top: data.top,
      left: data.left,
      fontScale: data.fontScale,
      fontAngle: data.fontAngle,
      fontSize: selectedFontSize.value,
      opacity: selectedTextOpacity.value,
      googleFontFamily: selectedFontFamily.value,
      fontAlign: selectedAlignment.value,
      fontColor: selectedColor.value,
    );
  }

  void updateTextWidget(int index, TextWidgetData updatedData) {
    textWidgets[index] = updatedData;
  }

  void deleteTextWidget(int index) {
    textWidgets.removeAt(index);
  }

  void onChangeBg() {
    selectedIndex.value =
        (selectedIndex.value + 1) % GenerateColor.instance.gradientList.length;
  }

  onEditorTap(StoryTextEditor index) {
    selectorEditorIndex.value = index;
  }

  void onFontFamilySelect(GoogleFontFamily fontFamily, int type) {
    if (selectedFontFamily.value != fontFamily) {
      selectedFontFamily.value = fontFamily;
    } else {
      selectedFontFamily.value = null;
    }

    if (type == 1) {
      outerFontFamilyList
        ..removeWhere((e) => e.fontName == fontFamily.fontName)
        ..insert(0, fontFamily);
    }
  }

  onSearchFontFamily(String value) {
    if (value.isEmpty) {
      // If query is empty, restore the original list
      filteredFontFamilyList.assignAll(fontFamilyList);
    } else {
      // Filter fontFamilyList based on the query
      filteredFontFamilyList.assignAll(fontFamilyList
          .where((font) => font.fontName.toLowerCase().contains((value).toLowerCase()))
          .toList());
    }
  }

  void openFontSheet() async {
    Get.bottomSheet(const GoogleFontFamilySheet(), isScrollControlled: true, ignoreSafeArea: false)
        .then((value) {
      onSearchFontFamily('');
    });
  }

  // Call this when fonts are no longer needed to free memory
  void releaseAllFonts() {
    Loggers.success('Releasing fonts');
    for (var font in fontFamilyList) {
      font.clearCache(); // Clear cached styles
    }
    fontFamilyList.clear(); // Remove font list from memory
    filteredFontFamilyList.clear();
  }
}

class TextEditor {
  String image;
  String title;

  TextEditor({required this.image, required this.title});
}

class GoogleFontFamily {
  final String fontName;
  TextStyle? _style; // Lazy-loaded style

  GoogleFontFamily({required this.fontName});

  // Lazy getter to fetch style only when needed
  TextStyle get style {
    _style ??= GoogleFonts.getFont(fontName); // Load only when accessed
    return _style ?? TextStyleCustom.outFitRegular400();
  }

  // Release memory manually
  void clearCache() {
    _style = null; // Remove stored TextStyle
  }
}

enum FontAlign {
  start,
  center,
  end,
  justify;

  static const Map<FontAlign, IconData> _iconMap = {
    FontAlign.start: Icons.format_align_left_rounded,
    FontAlign.center: Icons.format_align_center_rounded,
    FontAlign.end: Icons.format_align_right_rounded,
    FontAlign.justify: Icons.format_align_justify_rounded,
  };

  static const Map<FontAlign, TextAlign> _alignMap = {
    FontAlign.start: TextAlign.left,
    FontAlign.center: TextAlign.center,
    FontAlign.end: TextAlign.end,
    FontAlign.justify: TextAlign.justify,
  };

  IconData get icon => _iconMap[this]!;

  TextAlign get align => _alignMap[this]!;
}

enum StoryTextEditor {
  font,
  style,
  color,
  opacity;
  // textSize;

  static const Map<StoryTextEditor, String> imageMap = {
    StoryTextEditor.font: AssetRes.icTextFont,
    StoryTextEditor.style: AssetRes.icTextStyle,
    StoryTextEditor.color: AssetRes.icTextColor,
    StoryTextEditor.opacity: AssetRes.icTextOpacity,
    // StoryTextEditor.textSize: AssetRes.icTextSize,
  };

  static const Map<StoryTextEditor, String> titleMap = {
    StoryTextEditor.font: 'Font',
    StoryTextEditor.style: 'Style',
    StoryTextEditor.color: 'Color',
    StoryTextEditor.opacity: 'Opacity',
    // StoryTextEditor.textSize: 'Size',
  };

  String get image => imageMap[this]!;

  String get title => titleMap[this]!;
}
