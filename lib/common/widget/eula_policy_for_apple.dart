import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class EulaPolicyForApple extends StatefulWidget {
  const EulaPolicyForApple({super.key});

  @override
  State<EulaPolicyForApple> createState() => _EulaPolicyForAppleState();
}

class _EulaPolicyForAppleState extends State<EulaPolicyForApple> {
  late WebViewControllerPlus _controller;

  @override
  void initState() {
    _controller = WebViewControllerPlus()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {},
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'));
    super.initState();
  }

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: gestureRecognizers,
    );
  }
}
