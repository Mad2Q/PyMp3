import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

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
  static List<String> gits = ["https://github.com/underdoggit2"];
  final List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6, 0.8, 0.4, 0.7, 0.6, 0.4, 0.7, 0.6],
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  // In the Future
  Future<String> getHtml(String url) async {
    final response = await http.get(Uri.parse(url), headers: {
      "Access-Control_Allow_Origin": "*",
    });

    print(response);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //...body_col(),
              ...graph(),
            ],
          ),
        ),
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

  List<Widget> graph() {
    return [
      const Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Text(
          "Tasks Track",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      LineGraph(
        features: features,
        size: Size(520, 400),
        labelX: [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ],
        labelY: ['20%', '40%', '60%', '80%', '100%'],
        showDescription: true,
        graphColor: Colors.black,
        graphOpacity: 0.2,
        verticalFeatureDirection: true,
        descriptionHeight: 130,
      )
    ];
  }

  loadAsset() async {
    var myData = await rootBundle.loadString("data/date.csv");
    List<List<dynamic>> csvTable =
        CsvToListConverter(fieldDelimiter: " ", eol: "\n").convert(myData);
    setState(() {
      date = csvTable;
    });
    print(date);
    buildFeature(date);
  }

  List<List> buildFeature(List<List<dynamic>> contr) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String title = "";
    List<List<dynamic>> tmp = [];
    List<int> count_month_contr = new List<int>.filled(months.length, 0);

    for (List<dynamic> c in contr) {
      print(c);
      if (title != c[0]) {
        if (title != "") {
          List<dynamic> a = [c[0]];
          a.add(count_month_contr);
          tmp.add(a);
        }

        title = c[0];
        count_month_contr = new List<int>.filled(months.length, 0);
      }
      months.asMap().forEach((index, month) {
        if (c[2] == month) {
          count_month_contr[index] += 1;
        }
      });
      print(count_month_contr);
    }
    for (var e in tmp) {
      print(e);
    }
    return tmp;
  }
}
