import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<String> gits = ["https://github.com/underdoggit2"];
  WebViewController webview_controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: webview_controller,
    );
  }

  Widget body() {
    return Column(
      children: [
        ...body_col(),
      ],
    );
  }

  Widget body_col_e(String git) {
    return Container();
  }

  List<Widget> body_col() {
    List<Widget> wids = [];
    for (String git in gits) {
      wids.add(body_col_e(git));
    }
    return wids;
  }
}
