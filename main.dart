import 'dart:convert';
import 'dart:html';
import 'package:csv/csv.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/card.dart' as mat;
import 'package:flutter/services.dart';
import 'package:gitweb/make_payment.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import 'dart:io' as read;
import 'package:paypal_sdk/catalog_products.dart';
import 'package:paypal_sdk/core.dart';
import 'package:paypal_sdk/src/webhooks/webhooks_api.dart';
import 'package:paypal_sdk/subscriptions.dart';
import 'package:paypal_sdk/webhooks.dart';

const _clientId =
    'AXWmM4mCdjIZOA5CFoc0Zp5l7IkEVYUqW2yvFW8hRrlIjjV89CXWUTDMrAtzBCBrN8Y7_2KkiWTbe4ay';
const _clientSecret =
    'EFuh3WfX-OBUD63lEUjlz2K7y6HlwmxmiA7ebH8JzFjD0b_dZe-AojHJb5AysxQT6QdfTfOpl6dYaQXU';

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
  late List<List<dynamic>> date;
  String github_url = "https://github.com/";
  static Set<String> gits = new Set();
  final List<Feature> features = [];
  late WebViewXController webviewController;
  String str_button = "";

  //Paypal things
  AccessToken? accessToken; // load existing token here if available
  var paypalEnvironment;
  var payPalHttpClient;

  void loadPp() {
    paypalEnvironment = PayPalEnvironment.sandbox(
        clientId: _clientId, clientSecret: _clientSecret);

    payPalHttpClient =
        PayPalHttpClient(paypalEnvironment, accessToken: accessToken,
            accessTokenUpdatedCallback: (accessToken) async {
      // Persist token for re-use
    }, loggingEnabled: true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: makePayment());
  }
}
