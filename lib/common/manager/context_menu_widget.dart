import 'package:figma_squircle_updated/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:shortzz/utilities/text_style_custom.dart';
import 'package:shortzz/utilities/theme_res.dart';

class Menu {
  final List<MenuAction> children;

  Menu({required this.children});
}

class MenuAction {
  final String title;
  final VoidCallback callback;

  MenuAction({required this.title, required this.callback});
}

typedef MenuProvider = Menu? Function(BuildContext context);

class ContextMenuWidget extends StatelessWidget {
  final Widget child;
  final MenuProvider menuProvider;

  const ContextMenuWidget({
    super.key,
    required this.child,
    required this.menuProvider,
  });

  Future<void> _showMenu(BuildContext context, Offset globalPosition) async {
    final menu = menuProvider(context);
    if (menu == null || menu.children.isEmpty) return;

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(globalPosition, globalPosition),
        Offset.zero & overlay.size,
      ),
      color: bgLightGrey(context),
      shape: SmoothRectangleBorder(borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)),
      items: menu.children
          .asMap()
          .entries
          .map(
            (entry) => PopupMenuItem<int>(
              value: entry.key,
              height: 30,
              child: Text(
                entry.value.title,
                style: TextStyleCustom.outFitRegular400(color: textDarkGrey(context)),
              ),
            ),
          )
          .toList(),
    );

    if (selected != null) {
      menu.children[selected].callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        // Save the tap position for longPress
        final tapPosition = details.globalPosition;
        // Wait for longPress
        GestureDetector(onLongPress: () => _showMenu(context, tapPosition));
      },
      onLongPressStart: (details) {
        _showMenu(context, details.globalPosition);
      },
      child: child,
    );
  }
}
