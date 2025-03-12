
import 'package:webview_flutter/webview_flutter.dart';

import '../../../Activity_Global.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}
class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
  
    controller = WebViewController()
      ..loadRequest(
        Uri.parse("https://meet.google.com/landing"),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
          controller: controller,
      
      ),
    );
  }
}