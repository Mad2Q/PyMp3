import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<String> gits = ["https://github.com/underdoggit2"];
  WebViewController webview_controller = WebViewController();

  @override
  void initState() {
    super.initState();
    webview_controller.setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.github.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body());
  }

  Widget body() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //...body_col(),
          Container(
            height: 100,
            width: 100,
            color: Colors.black26,
            child: Text("sd"),
          ),
          Container(
            height: 300,
            width: 300,
            child: WebViewWidget(controller: webview_controller),
          ),
        ],
      ),
    );
  }

  Widget body_col_e(String git) {
    return Container(
      height: 100,
      width: 100,
      color: Colors.black12,
      child: Text(git),
    );
  }

  List<Widget> body_col() {
    List<Widget> wids = [];
    for (String git in gits) {
      wids.add(body_col_e(git));
    }
    return wids;
  }
}
